class spraints::est {
  file { "/etc/localtime":
    ensure => "/usr/share/zoneinfo/America/Indiana/Indianapolis",
    require => File["/usr/share/zoneinfo/America/Indiana/Indianapolis"],
  }
}
