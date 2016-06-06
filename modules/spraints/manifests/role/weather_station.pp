class spraints::role::weather_station {
  include spraints::services::collectd
  include spraints::services::fowsr

  # fowsr + collectd
  file { "/etc/collectd/collectd.conf.d/fowsr.conf":
    ensure => present,
    owner  => "root",
    mode   => "444",
    source => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/fowsr.conf",
  }

  Vcsrepo["/opt/fowsr"] ~> Service["collectd"]

  # fowsr + wunderground (KINPICKA2)
  service { "fowsr-wunderground":
    ensure => running,
    subscribe => Vcsrepo["/opt/fowsr"],
    require => [
      User["fowsr"],
      Class["spraints::services::fowsr"],
    ],
  }

  spraints::service_config { "fowsr-wunderground":
    notify => Service["fowsr-wunderground"],
  }
}
