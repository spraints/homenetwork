class spraints::app::fowsr {
  vcsrepo { "/opt/fowsr":
    ensure => present,
    provider => git,
    user => "root",
    source => "https://github.com/spraints/fowsr",
    revision => "36a3cf2ae3e6217d36f27f410833fa3dfab071c5",
  }

  package { "libusb-dev":
    ensure => installed,
  }

  exec { "build fowsr":
    command => "/usr/bin/make clean all",
    cwd => "/opt/fowsr/fowsr.src",
    user => "root",
    refreshonly => true,
    subscribe => Vcsrepo["/opt/fowsr"],
    require => Package["libusb-dev"],
  }
}
