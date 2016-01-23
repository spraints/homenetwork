class spraints::role::caching_dns(
  $listen           = ["0.0.0.0"],
  $allowed_clients  = ["0.0.0.0/0"],
  $root_nameservers = ["8.8.8.8@53"],
){
  package { "unbound":
    ensure => installed,
  }

  service { "unbound":
    ensure  => "running",
    enable  => "true",
    require => Package["unbound"],
  }

  file { "/etc/unbound/unbound.conf.d/cache-the-google.conf":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => 444,
    content => template("spraints/etc/unbound.conf.erb"),
    notify  => Service["unbound"],
  }
}
