class spraints::app::visage {
  file { "/opt/visage":
    ensure => directory,
  }

  file { "/opt/visage/Gemfile":
    ensure => present,
    source => "puppet:///modules/spraints/opt/visage/Gemfile",
    require => File["/opt/visage"],
  }

  file { "/opt/visage/server":
    ensure => present,
    source => "puppet:///modules/spraints/opt/visage/server",
    mode => 755,
    require => File["/opt/visage"],
  }

  file { "/opt/visage/unicorn.rb":
    ensure => present,
    source => "puppet:///modules/spraints/opt/visage/unicorn.rb",
    require => File["/opt/visage"],
  }

  exec { "bundle visage":
    command => "/usr/bin/env bundle install --binstubs bin --path vendor/gems",
    cwd => "/opt/visage",
    subscribe => File["/opt/visage/Gemfile"],
    refreshonly => true,
  }
}
