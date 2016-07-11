class spraints::tools::nfdump {
  package {
    "nfdump":
      ensure => "installed";
  }

  service { "nfdump":
    ensure  => "running",
    require => Package["nfdump"],
  }
}
