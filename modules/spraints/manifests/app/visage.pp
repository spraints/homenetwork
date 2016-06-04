class spraints::app::visage {
  file { "/opt/visage":
    ensure => directory,
    owner  => "visage",
    require => User["visage"],
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

  if $::lsbdistcodename == "trusty" {
    $rrdpackage = "librrd-ruby"
  } else {
    $rrdpackage = "ruby-rrd"
  }

  exec { "bundle visage":
    command => "/usr/bin/env bundle install --binstubs bin --path vendor/gems",
    unless => "/usr/bin/env bundle check",
    user => "visage",
    cwd => "/opt/visage",
    subscribe => File["/opt/visage/Gemfile"],
    require => [
      Package["build-essential"],
      Package["bundler"],
      Package[$rrdpackage],
      Package["ruby"],
      Package["ruby-dev"],
      User["visage"],
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
