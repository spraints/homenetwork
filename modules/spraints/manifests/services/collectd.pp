class spraints::services::collectd {
  package { "collectd":
    ensure => "installed",
  }

  service { "collectd":
    ensure  => "running",
    enable  => "true",
    require => Package["collectd"],
  }

  file { "/etc/collectd/collectd.conf":
    notify  => Service["collectd"],
    mode    => 644,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/etc/collectd/collectd.conf",
  }

  file { "/etc/collectd/collectd.conf.d/config.conf":
    notify  => Service["collectd"],
    mode    => 644,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/config.conf",
  }
}
