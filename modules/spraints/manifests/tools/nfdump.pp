class spraints::tools::nfdump {
  package {
    "nfdump":
      ensure => "installed";
  }

  service { "nfcapd":
    ensure  => "running",
    require => Package["nfdump"],
  }
}
