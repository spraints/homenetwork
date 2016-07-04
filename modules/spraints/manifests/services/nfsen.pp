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
    creates => "/var/www/nfsen",
    cwd     => "/var/www",
    require => Exec["download nfsen"],
  }

  file { "/etc/nfsen.conf":
    ensure  => present,
    mode    => 444,
    owner   => root,
    content => template("spraints/etc/nfsen.conf.erb"),
  }

  exec { "install nfsen":
    command => "/var/www/nfsen/install.pl /etc/nfsen.conf && touch /var/www/nfsen.installed",
    path    => "/usr/bin:/bin",
    creates => "/var/www/nfsen.installed",
    require => [ Exec["untar nfsen"], File["/etc/nfsen.conf"] ],
  }
}
