# Routes traffic to zig wireless by default. Some apps
# are routed to AT&T always. Some hosts can self-select
# AT&T for all of their traffic for a limited time.
class spraints::role::router(
  $zig_if = "en1",
  $zig_ip = "192.168.3.1",
  $local_zig_ip = "192.168.3.2",
  $att_if = "en2",
  $att_ip = "192.168.0.1",
  $local_att_ip = "192.168.0.2",
  $inf_if = "en3",
  $int_ip = "192.168.100.2",
) {
  include spraints::app::zig-or-att

  # IP addresses

  $hostname_ifs = {
    "hostname.${zig_if}" => "inet $local_zig_ip 255.255.255.0 $zig_bcast",
    "hostname.${att_if}" => "inet $local_att_ip 255.255.255.0 $att_bcast",
    "hostname.${int_if}" => "inet $int_ip       255.255.255.0 $int_bcast",
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
