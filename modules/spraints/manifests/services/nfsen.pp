class spraints::services::nfsen {
  package { ["apache2", "libapache2-mod-php5", "php5-common",
    "rrdtool", "libmailtools-perl", "librrds-perl", "libio-socket-ssl-perl"]:
      ensure => installed;
    "nfdump":
      ensure => installed;
  }

  $nfsen_version = "1.3.6p1"
  $nfsen_tarfile = "nfsen-${nfsen_version}.tar.gz"

  exec { "download nfsen":
    command => "/usr/bin/curl -L -o /tmp/nfsen.part http://sourceforge.net/projects/nfsen/files/stable/nfsen-${nfsen_version}/${nfsen_tarfile} && /bin/mv /tmp/nfsen.part /var/www/${nfsen_tarfile}",
    creates => "/var/www/${nfsen_tarfile}",
  }

  exec { "untar nfsen":
    command => "/bin/tar zxvf ${nfsen_tarfile} && /bin/mv nfsen-${nfsen_version} nfsen",
    creates => "nfsen",
    cwd     => "/var/www",
    require => Exec["download nfsen"],
  }
}
