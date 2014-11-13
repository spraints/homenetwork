class spraints::services::ntp {
  package { "ntp":
    ensure => "present",
  }

  service { "ntp":
    ensure => "running",
    require => Package["ntp"],
  }
}
