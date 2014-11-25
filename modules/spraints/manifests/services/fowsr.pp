class spraints::services::fowsr {
  include spraints::app::fowsr

  service { "fowsr":
    ensure => running,
    require => [
      User["fowsr"],
      File["/etc/init/fowsr.conf"],
      Class["spraints::app::fowsr"],
    ],
  }

  file { "/etc/init/fowsr.conf":
    ensure => present,
    source => "puppet:///modules/spraints/etc/init/fowsr.conf",
    owner => "root",
    group => "root",
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
