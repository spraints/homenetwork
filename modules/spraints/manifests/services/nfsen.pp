class spraints::services::nfsen {
  package { ["apache2", "libapache2-mod-php5", "php5-common",
    "rrdtool", "libmailtools-perl", "librrds-perl", "libio-socket-ssl-perl"]:
      ensure => installed
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
    requires=> Exec["download nfsen"],
  }


  exec { "download nfsen":
    command => "rm -f nfsen-1.3.6p1.tar.gz; wget http://sourceforge.net/projects/nfsen/files/stable/nfsen-1.3.6p1/nfsen-1.3.6p1.tar.gz && tar zxvf nfsen-1.3.6p1.tar.gz && mv nfsen-1.3.6p1 nfsen",
    cwd     => "/var/www",
    creates => "/var/www/nfsen",
    path    => "/bin:/usr/bin",
  }
}
