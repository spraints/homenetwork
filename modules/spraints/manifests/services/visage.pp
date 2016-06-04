class spraints::services::visage {
  include spraints::app::visage

  $visage_config_path = "/var/local/visage"

  file { "/opt/visage/config.ru":
    ensure => present,
    owner => "visage",
    group => "visage",
    mode => 644,
    source => "puppet:///modules/spraints/opt/visage/config.ru",
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

  service { "visage":
    ensure => running,
    require => [
      User["visage"],
      Class["spraints::app::visage"],
      File["/var/local/visage"],
    ],
    subscribe => [
      Exec["bundle visage"],
      File["/opt/visage/config.ru"],
    ],
  }

  spraints::service_config { "visage":
    notify             => Service["visage"],
    visage_config_path => $visage_config_path,
  }

  file { "$visage_config_path/profiles.yaml.d":
    ensure => directory,
    owner => "visage",
    group => "visage",
  }

  file { "$visage_config_path/profiles.yaml.d/README":
    ensure => present,
    owner => "visage",
    group => "visage",
    mode => "0444",
    content => "# This file is created by puppet.\n# Add files to $visage_config_path with puppet.\n\n",
    notify => Exec["build visage profile"],
  }

  exec { "build visage profile":
    command => "cat $visage_config_path/profiles.yaml.d/* > $visage_config_path/profiles.yaml",
    path => "/bin",
    user => "visage",
    group => "visage",
  }
}
