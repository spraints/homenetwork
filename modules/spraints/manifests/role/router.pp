# Routes traffic to zig wireless by default. Some apps
# are routed to AT&T always. Some hosts can self-select
# AT&T for all of their traffic for a limited time.
class spraints::role::router(
  $zig_if = "en1",
  $att_if = "en2",
  $inf_if = "en3",
  $int_ip = "192.168.100.2",
  $int_net = "192.168.100",
  $dhcp_reservations = { "host" => {"ip" => "192.168.100.49", "mac" => "11:22:33:44:55:66"} },
) {
  include spraints::app::zig-or-att

  $exec_path = "/bin:/usr/bin:/sbin:/usr/sbin"

  # IP addresses

  $hostname_ifs = {
    "hostname.${zig_if}" => "dhcp",
    "hostname.${att_if}" => "dhcp",
    "hostname.${int_if}" => "inet $int_ip 255.255.255.0 $int_net.255",
  }

  file { [
           "/etc/hostname.${zig_if}",
           "/etc/hostname.${att_if}",
           "/etc/hostname.${int_if}",
         ]:
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "444",
    content => $hostname_ifs[$name],
    notify  => Exec["restart networking"],
  }

  exec { "restart networking":
    command => "sh /etc/netstart ${zig_if} && sh /etc/netstart ${att_if} && sh /etc/netstart ${int_if}",
    path    => $exec_path,
    user    => "root",
    group   => "root",
  }

  # Firewall

  file { "/etc/pf.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "444",
    content => template("spraints/etc/pf.conf.erb"),
    notify  => Exec["reload pf.conf"],
  }

  exec { "reload pf.conf":
    command => "pfctl -e -f /etc/pf.conf",
    path    => $exec_path,
    user    => "root",
    group   => "root",
  }

  # DNS mirror

  exec { "start unbound":
    command => "rcctl enable unbound && rcctl stop unbound && rcctl start unbound",
    path    => $exec_path,
    user    => "root",
    group   => "root",
  }

  file { "/var/unbound/etc/unbound.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "444",
    content => template("spraints/var/unbound/etc/unbound.conf.erb"),
    notify  => Exec["start unbound"],
  }

  # DHCP server

  exec { "start dhcpd $int_if":
    command => "rcctl enable dhcpd && rcctl set dhcpd flags $int_if && rcctl stop dhcpd && rcctl start dhcpd",
    path    => $exec_path,
    user    => "root",
    group   => "root",
  }

  file { "/etc/dhcpd.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "444",
    content => template("spraints/etc/dhcpd.conf.erb"),
    notify  => Exec["start dhcpd $int_if"],
  }
}
