class spraints::tools::ntop {
  if $::lsbdistcodename == "xenial" {
    exec { "install ntop apt source":
      command => "/usr/bin/wget http://apt-stable.ntop.org/16.04/all/apt-ntop-stable.deb && /usr/bin/dpkg -i apt-ntop-stable.deb && apt-get update",
      cwd     => "/tmp",
      unless  => "/usr/bin/dpkg -l apt-ntop-stable | /bin/grep ^ii",
    }
  }

  package { ["nprobe", "ntopng"]:
    ensure  => present,
    require => Exec["install ntop apt source"],
  }
}
