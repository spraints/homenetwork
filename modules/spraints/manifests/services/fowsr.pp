class spraints::services::fowsr {
  include spraints::app::fowsr

  service { "fowsr":
    ensure => running,
    subscribe => Vcsrepo["/opt/fowsr"],
    require => [
      User["fowsr"],
      Spraints::ServiceConfig["fowsr"],
      Class["spraints::app::fowsr"],
    ],
  }

  spraints::service_config { "fowsr":
    notify => Service["fowsr"],
  }

  user { "fowsr":
    ensure => present,
    gid => "fowsr",
    require => Group["fowsr"],
  }

  group { "fowsr":
    ensure => present,
  }
}
