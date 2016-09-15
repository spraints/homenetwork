# Routes traffic to zig wireless by default. Some apps
# are routed to AT&T always. Some hosts can self-select
# AT&T for all of their traffic for a limited time.
class spraints::role::router(
  $int_if = "re2",
  $int_ip = "192.168.100.2",
  $int_net = "192.168.100",
  $hbb_if = "re3",
  $hbb_ip = "dhcp",
  $hbb_bcast = undef,
  $hbb_net = undef,
  $dhcp_reservations = { "host" => {"ip" => "192.168.100.49", "mac" => "11:22:33:44:55:66"} },
  $dhcp_name_servers = [ "192.168.100.2", "8.8.8.8" ],
  $collectd_master = undef,
  $hbb_test_routes = { },
  $nameservers = ["8.8.8.8"],
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
      notify  => Exec["reload pf.conf"];
    "re1":
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

  file { "/etc/resolv.conf":
    ensure  => present,
    owner   => "root",
    mode    => "644",
    content => template("spraints/etc/resolv.conf.router.erb"),
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
    ensure  => absent,
    command => "${sprouter_wrapper} >${sprouter_log} 2>&1",
    user    => "root",
  }

  file { $sprouter_prefs:
    ensure => absent,
  }

  file { $sprouter_prefs_fragment:
    ensure => absent,
  }

  file { $sprouter_root:
    ensure  => absent,
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

    file { "/usr/local/bin/collectd-smart":
      ensure  => present,
      owner   => "root",
      mode    => "4555",
      content => template("spraints/usr/local/bin/collectd-smart.erb"),
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
