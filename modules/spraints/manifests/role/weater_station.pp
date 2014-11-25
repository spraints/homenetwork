class spraints::role::weather_station {
  include spraints::services::collectd
  include spraints::services::fowsr

  # fowsr + collectd
  file { "/etc/collectd/collectd.conf.d/fowsr.conf":
    ensure => present,
    owner => "root",
    group => "root",
    source => "puppet:///modules/spraints/etc/collectd.conf.d/fowsr.conf",
  }

  # fowsr + wunderground (KINPICKA2)
  service { "fowsr-wunderground":
    ensure => running,
    require => [
      User["fowsr"],
      File["/etc/init/fowsr-wunderground.conf"],
      Class["spraints::services::fowsr"],
    ],
  }

  file { "/etc/init/fowsr-wunderground.conf":
    ensure => present,
    source => "puppet:///modules/spraints/etc/init/fowsr-wunderground.conf",
    owner => "root",
    group => "root",
  }
}
