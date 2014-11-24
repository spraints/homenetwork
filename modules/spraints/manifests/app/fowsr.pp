class spraints::app::fowsr {
  vcsrepo { "/opt/fowsr":
    ensure => present,
    provider => git,
    user => "root",
  }

  package { "libusb-dev":
    ensure => installed,
  }

  exec { "build fowsr":
    command => "/usr/bin/make clean all",
    cwd => "/opt/fowsr/fowsr.src"
    user => "root",
    refreshonly => true,
    subscribe => Vcsrepo["/opt/fowsr"],
    require => Package["libusb-dev"],
  }
}
