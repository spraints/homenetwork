class spraints::services::ntp {
  if $::operatingsystem != "OpenBSD" {
    package { "ntp":
      ensure => "present",
    }

    service { "ntp":
      ensure => "running",
      require => Package["ntp"],
    }
  }
}
