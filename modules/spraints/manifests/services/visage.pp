class spraints::services::visage {
  include spraints::app::visage

  $visage_config_path = "/var/local/visage"

  file { "/etc/init/visage.conf":
    ensure => present,
    content => template("spraints/opt/visage/server.erb"),
    owner => "root",
    group => "root",
  }

  user { "visage":
    ensure => present,
    gid => "visage",
    require => Group["visage"],
  }

  group { "visage":
    ensure => present,
  }

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
    ensure => absent,
  }

  service { "visage":
    ensure => running,
    require => [
      File["/etc/init/visage.conf"],
      User["visage"],
      Class["spraints::app::visage"],
      File["/var/local/visage"],
    ],
    subscribe => [
      File["/etc/init/visage.conf"],
      Exec["bundle visage"],
    ],
  }
}
