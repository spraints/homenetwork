class spraints::app::fowsr {
  vcsrepo { "/opt/fowsr":
    ensure => present,
    provider => git,
    user => "root",
    source => "https://github.com/spraints/fowsr",
    revision => "0763bae34f9603b5ab00920fa05979d690b94c40",
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
