class spraints::app::visage {
  file { "/opt/visage":
    ensure => directory,
  }

  file { "/opt/visage/Gemfile":
    ensure => present,
    source => "puppet:///modules/spraints/opt/visage/Gemfile",
    require => File["/opt/visage"],
  }

  exec { "bundle visage":
    command => "/usr/bin/env bundle install --binstubs bin --path vendor/gems",
    cwd => "/opt/visage",
    subscribe => File["/opt/visage/Gemfile"],
  }
}
