class spraints::services::visage {
  include spraints::app::visage

  file { "/etc/init/visage.conf":
    ensure => present,
    source => "puppet:///modules/spraints/etc/init/visage.conf",
  }

  user { "visage":
    ensure => present,
    gid => "visage",
    require => Group["visage"],
  }

  group { "visage":
    ensure => present,
  }

  service { "visage":
    ensure => running,
    require => [
      File["/etc/init/visage.conf"],
      User["visage"],
      Class["spraints::app::visage"],
    ],
    subscribe => Exec["bundle visage"],
  }
}
