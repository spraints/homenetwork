# Routes traffic to zig wireless by default. Some apps
# are routed to AT&T always. Some hosts can self-select
# AT&T for all of their traffic for a limited time.
class spraints::role::router(
  $att_if = "re1",
  $att_gw = "192.168.0.1",
  $att_ip = "dhcp",
  $int_if = "re2",
  $int_ip = "192.168.100.2",
  $int_net = "192.168.100",
  $hbb_if = "re3",
  $hbb_gw = "38.65.252.1",
  $hbb_ip = "dhcp",
  $hbb_bcast = undef,
  $hbb_net = undef,
  $dhcp_reservations = { "host" => {"ip" => "192.168.100.49", "mac" => "11:22:33:44:55:66"} },
  $dhcp_name_servers = [ "192.168.100.2", "192.168.100.81" ],
  $collectd_master = undef,
  $att_test_routes = { },
  $hbb_test_routes = { },
  $sprouter_config = undef,
  $sprouter_config_fragment = undef,
  $sprouter_config_url = undef,
) {
  #include spraints::app::zig-or-att

  $exec_path = "/bin:/usr/bin:/sbin:/usr/sbin"

  # IP addresses

  # DHCP on these is nice, because there's less to configure manually.
  # But DHCP on these bites because I can't choose a default route with /etc/mygate
  # and pf will barf if the NIC isn't connected, because the interface won't have an IP
  # address.
  spraints::device::interface {
    $int_if:
      address => $int_ip,
      notify  => Exec["reload pf.conf"];
    "re0":
      address => undef,
      notify  => Exec["reload pf.conf"];
    $att_if:
      address => $att_ip,
      notify  => Exec["reload pf.conf"];
    $hbb_if:
      address => $hbb_ip,
      netmask => $hbb_net,
      bcast   => $hbb_bcast,
      notify  => Exec["reload pf.conf"];
  }

  spraints::device::pflow { "pflow0":
    flowdst     => "${collectd_master}:2055",
    flowsrc     => "${int_ip}",
    pflowproto  => "10",
  }

  file { "/etc/mygate":
    ensure  => present,
    owner   => "root",
    mode    => "444",
    content => "${hbb_gw}\n",
  }

  file { "/etc/rc.local":
    ensure  => present,
    owner   => "root",
    mode    => "444",
    content => template("spraints/etc/rc.local.erb"),
  }

  file { "/etc/resolv.conf":
    ensure  => present,
    owner   => "root",
    mode    => "644",
    content => "nameserver 127.0.0.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4\nlookup file bind\n",
  }

  ###
  # Firewall

  # pf is included in the base OS on OpenBSD.

  file { "/etc/pf.conf":
    ensure  => present,
    owner   => "root",
    mode    => "600",
    content => template("spraints/etc/pf.conf.erb"),
    notify  => Exec["reload pf.conf"],
  }

  cron { "hbbgw":
    ensure  => present,
    command => "/opt/updatehbbgw",
    user    => "root",
    require => [ File["/opt/updatehbbgw"] ],
  }

  file { "/opt/updatehbbgw":
    ensure  => present,
    owner   => "root",
    mode    => "555",
    content => template("spraints/opt/updatehbbgw.erb"),
  }

  exec { "reload pf.conf":
    command => "pfctl -n -f /etc/pf.conf && pfctl -f /etc/pf.conf",
    path    => $exec_path,
    user    => "root",
    refreshonly => true,
  }

  file { "/etc/sysctl.conf":
    ensure  => present,
    owner   => "root",
    mode    => "444",
    content => "net.inet.ip.forwarding=1\n",
    notify  => Exec["enable ip forwarding"],
  }

  exec { "enable ip forwarding":
    command => "sysctl net.inet.ip.forwarding=1",
    path    => $exec_path,
    user    => "root",
    onlyif  => "sysctl | grep net.inet.ip.forwarding=0",
  }

  ###
  # Sprouter

  $sprouter_root_parent = "/opt"
  $sprouter_root        = "${sprouter_root_parent}/sprouter"
  $sprouter_wrapper     = "${sprouter_root}/run"
  $sprouter_gem         = "${sprouter_root}/vendored-gem"
  $sprouter_log         = "/var/log/sprouter.log"
  $sprouter_prefs          = "/etc/sprouter.conf"
  $sprouter_prefs_fragment = "/etc/sprouter.conf.fragment"

  cron { "sprouter":
    ensure  => present,
    command => "${sprouter_wrapper} >${sprouter_log} 2>&1",
    user    => "root",
    require => [ Exec["bundle sprouter"], File[$sprouter_wrapper] ],
  }

  file { $sprouter_wrapper:
    ensure  => present,
    owner   => "root",
    mode    => "555",
    content => template("spraints/opt/sprouter/run.erb"),
  }

  if $sprouter_config == undef {
    file { $sprouter_prefs:
      ensure => absent,
    }
  } else {
    file { $sprouter_prefs:
      ensure  => present,
      owner   => "root",
      mode    => "444",
      content => $sprouter_config,
    }
  }

  if $sprouter_config_fragment == undef {
    file { $sprouter_prefs_fragment:
      ensure => absent,
    }
  } else {
    file { $sprouter_prefs_fragment:
      ensure  => present,
      owner   => "root",
      mode    => "444",
      content => $sprouter_config_fragment,
    }
  }

  vcsrepo { $sprouter_gem:
    ensure   => present,
    provider => git,
    user     => "root",
    source   => "https://github.com/spraints/sprouter",
    revision => "3d0b3821abad66dde44325855bf71fc8c2e2781c",
    require  => File[$sprouter_root],
  }

  file { "${sprouter_root}/Gemfile":
    ensure  => present,
    owner   => "root",
    mode    => "444",
    content => "gem 'sprouter', path: '${sprouter_gem}'",
    require => File[$sprouter_root],
  }

  exec { "bundle sprouter":
    command => "bundle --path .bundle --binstubs bin",
    cwd     => $sprouter_root,
    unless  => "bundle check && test -f bin/sprouter",
    path    => "/usr/local/bin",
    user    => "root",
    require => [ File["${sprouter_root}/Gemfile"], Vcsrepo[$sprouter_gem] ],
  }

  file { $sprouter_root:
    ensure  => directory,
    owner   => "root",
    mode    => "555",
    require => File[$sprouter_root_parent],
  }

  file { $sprouter_root_parent:
    ensure  => directory,
  }

  ###
  # DNS mirror

  # This reinstalls itself every time i run puppet!
  #package { "unbound":
  #  ensure => installed,
  #}

  exec { "start unbound":
    command => "rcctl enable unbound && rcctl stop unbound && rcctl start unbound",
    path    => $exec_path,
    user    => "root",
    #require => Package["unbound"],
    refreshonly => true,
  }

  file { "/var/unbound/etc/unbound.conf":
    ensure  => present,
    owner   => "root",
    mode    => "444",
    content => template("spraints/var/unbound/etc/unbound.conf.erb"),
    notify  => Exec["start unbound"],
  }

  ###
  # DHCP server

  # dhcpd is included in the base OS on OpenBSD.

  exec { "start dhcpd $int_if":
    command => "rcctl enable dhcpd && rcctl set dhcpd flags $int_if && rcctl stop dhcpd && rcctl start dhcpd",
    path    => $exec_path,
    user    => "root",
    refreshonly => true,
  }

  file { "/etc/dhcpd.conf":
    ensure  => present,
    owner   => "root",
    mode    => "444",
    content => template("spraints/etc/dhcpd.conf.erb"),
    notify  => Exec["start dhcpd $int_if"],
  }

  ###
  # Metrics

  if $collectd_master != undef {
    package { "collectd":
      ensure => installed,
    }

    file { "/etc/collectd.conf":
      ensure  => present,
      owner   => "root",
      mode    => "444",
      content => template("spraints/etc/collectd-router.conf.erb"),
      notify  => Exec["start collectd"],
    }

    file { "/usr/local/bin/collectd-pf-tables":
      ensure  => present,
      owner   => "root",
      mode    => "4555",
      content => template("spraints/usr/local/bin/collectd-pf-tables.erb"),
      notify  => Exec["start collectd"],
    }

    exec { "start collectd":
      command     => "rcctl enable collectd && rcctl stop collectd && rcctl start collectd",
      path        => $exec_path,
      user        => "root",
      refreshonly => true,
      require     => Package["collectd"],
    }
  }
}
