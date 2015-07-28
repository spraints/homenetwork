class spraints::app::fowsr {
  vcsrepo { "/opt/fowsr":
    ensure => present,
    provider => git,
    user => "root",
    source => "https://github.com/spraints/fowsr",
    revision => "9b0962dd0128cb16a14f2b078b392dbb6faf0060",
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
