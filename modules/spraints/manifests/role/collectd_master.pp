define spraints::role::collectd_master {
  require spraints::services::collectd
  require spraints::services::snmp

  file { "/etc/collectd/collectd.conf.d/airport-snmp.conf":
    notify  => Service["collectd"],
    mode    => 600,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/airport-snmp.conf",
  }

  file { "/etc/collectd/collectd.conf.d/ping-the-world.conf":
    notify  => Service["collectd"],
    mode    => 600,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/ping-the-world.conf",
  }
}
