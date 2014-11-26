class spraints::app::fowsr {
  vcsrepo { "/opt/fowsr":
    ensure => present,
    provider => git,
    user => "root",
    source => "https://github.com/spraints/fowsr",
    revision => "40c7c9e0b58974a02e9973940d8a99d205b79929",
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
