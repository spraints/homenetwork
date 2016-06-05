class spraints::services::visage {
  include spraints::app::visage

  $visage_pidfile = "/var/run/visage.pid"
  $visage_config_path = "/var/local/visage"
  $visage_log_file = "/opt/visage/log/visage.log"

  file { "/opt/visage/config.ru":
    ensure => present,
    owner => "visage",
    group => "visage",
    mode => 644,
    source => "puppet:///modules/spraints/opt/visage/config.ru",
  }

  file { "/opt/visage/log":
    ensure => directory,
    owner => "visage",
    group => "visage",
    mode => 755,
    require => User["visage"],
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

  file { "/opt/visage/unicorn.rb":
    ensure => present,
    content => template("spraints/opt/visage/unicorn.rb.erb"),
    require => File["/opt/visage"],
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
    notify    => Service["visage"],
    sc_config => {
      visage_pidfile     => $visage_pidfile,
      visage_config_path => $visage_config_path,
      visage_log_file    => $visage_log_file,
    },
  }

  file { "/etc/logrotate.d/visage":
    ensure => present,
    content => "${visage_log_file} {\n  daily\n  rotate 7\n  delaycompress\n  compress\n  notifempty\n  missingok\n  postrotate\n    invoke-rc.d visage restart >/dev/null\n}\n",
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
