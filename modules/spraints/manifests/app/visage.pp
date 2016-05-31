class spraints::app::visage {
  file { "/opt/visage":
    ensure => directory,
  }

  file { "/opt/visage/Gemfile":
    ensure => present,
    source => "puppet:///modules/spraints/opt/visage/Gemfile",
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
    require => [
      Package["build-essential"],
      Package["bundler"],
      Package["librrd-ruby"],
      Package["ruby"],
      Package["ruby-dev"],
    ],
  }

  package {
    "build-essential":
      ensure => installed;
    "bundler":
      ensure => installed;
    "librrd4":
      ensure => installed;
    "ruby":
      ensure => installed;
    "ruby-dev":
      ensure => installed;
  }
}
