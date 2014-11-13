define spraints::role::collectd_master {
  package { "collectd":
    ensure => "installed",
  }

  service { "collectd":
    ensure  => "running",
    enable  => "true",
    require => Package["collectd"],
  }

  file { "/etc/collectd/collectd.conf.d/airport-snmp.conf":
    notify  => Service["collectd"],
    mode    => 600,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/airport-snmp.conf",
    require => Package["collectd"],
  }

  file { "/etc/collectd/collectd.conf.d/ping-the-world.conf":
    notify  => Service["collectd"],
    mode    => 600,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/ping-the-world.conf",
    require => Package["collectd"],
  }
}
