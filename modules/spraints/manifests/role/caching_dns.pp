class spraints::role::caching_dns {
  package { "unbound":
    ensure => installed,
  }

  service { "unbound":
    ensure  => "running",
    enable  => "true",
    require => Package["unbound"],
  }
}
