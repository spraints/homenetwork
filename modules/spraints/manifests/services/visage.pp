class spraints::services::visage {
  include spraints::app::visage

  file { "/etc/init/visage.conf":
    ensure => present,
    source => "puppet:///modules/spraints/etc/init/visage.conf",
  }

  service { "visage":
    ensure => running,
    require => [
      File["/etc/init/visage.conf"],
      Class["spraints::app::visage"],
    ],
    subscribe => Exec["bundle visage"],
  }
}
