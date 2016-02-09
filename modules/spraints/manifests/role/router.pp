# Routes traffic to zig wireless by default. Some apps
# are routed to AT&T always. Some hosts can self-select
# AT&T for all of their traffic for a limited time.
class spraints::role::router(
  $zig_if = "re0",
  $zig_gw = "192.168.3.1",
  $att_if = "re1",
  $att_gw = "192.168.0.1",
  $int_if = "re2",
  $int_ip = "192.168.100.2",
  $int_net = "192.168.100",
  $mgm_if = "re3",
  $dhcp_reservations = { "host" => {"ip" => "192.168.100.49", "mac" => "11:22:33:44:55:66"} },
) {
  #include spraints::app::zig-or-att

  $exec_path = "/bin:/usr/bin:/sbin:/usr/sbin"

  # IP addresses

  # DHCP on these is nice, because there's less to configure manually.
  # But DHCP on these bites because I can't choose a default route with /etc/mygate
  # and pf will barf if the NIC isn't connected, because the interface won't have an IP
  # address.
  spraints::device::interface { [$zig_if, $att_if, $mgm_if]:
    dhcp    => true,
    notify  => Exec["reload pf.conf"],
  }
  spraints::device::interface { $int_if:
    address => $int_ip,
    notify  => Exec["reload pf.conf"],
  }

  ###
  # Firewall

  # pf is included in the base OS on OpenBSD.

  file { "/etc/pf.conf":
    ensure  => present,
    owner   => "root",
    mode    => "444",
    content => template("spraints/etc/pf.conf.erb"),
    notify  => Exec["reload pf.conf"],
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
  # DNS mirror

  package { "unbound":
    ensure => installed,
  }

  exec { "start unbound":
    command => "rcctl enable unbound && rcctl stop unbound && rcctl start unbound",
    path    => $exec_path,
    user    => "root",
    require => Package["unbound"],
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
}
