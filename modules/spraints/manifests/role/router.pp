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

  # Firewall

  file { "/etc/pf.conf":
    ensure => present,
    owner  => "root",
    group  => "root",
    mode   => "444",
    source => template("spraints/etc/pf.conf.erb"),
    notify => Exec["reload pf.conf"],
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
