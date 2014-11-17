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

  $visage_config_path = "/var/local/visage"

  file { $visage_config_path:
    owner => "visage",
    group => "visage",
    ensure => directory,
    mode => 755,
    require => [
      User["visage"],
      Group["visage"],
    ],
  }

  file { "/opt/visage/server":
    ensure => present,
    content => template("spraints/opt/visage/server.erb"),
    mode => 755,
    require => [
      File["/opt/visage"],
      File["/var/local/visage"],
    ],
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
