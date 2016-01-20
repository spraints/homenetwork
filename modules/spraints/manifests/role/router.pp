# Routes traffic to zig wireless by default. Some apps
# are routed to AT&T always. Some hosts can self-select
# AT&T for all of their traffic for a limited time.
class spraints::role::router(
  $zig_if = "en1",
  $att_if = "en2",
  $inf_if = "en3",
  $int_ip = "192.168.100.2",
  $int_bcast = "192.168.100.255",
) {
  include spraints::app::zig-or-att

  # IP addresses

  $hostname_ifs = {
    "hostname.${zig_if}" => "dhcp",
    "hostname.${att_if}" => "dhcp",
    "hostname.${int_if}" => "inet $int_ip 255.255.255.0 $int_bcast",
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
    path    => "/bin:/usr/bin:/sbin:/usr/sbin",
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
    path    => "/sbin",
    user    => "root",
    group   => "root",
  }

  # DNS mirror
  # todo

  # DHCP server
}
