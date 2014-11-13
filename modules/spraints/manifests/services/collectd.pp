class spraints::services::collectd {
  package { "collectd":
    ensure => "installed",
  }

  service { "collectd":
    ensure  => "running",
    enable  => "true",
    require => Package["collectd"],
  }
}
