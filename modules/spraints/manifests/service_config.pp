define spraints::service_config {
  if $::operatingsystem == "Ubuntu" {
    if $::lsbdistcodename == "trusty" {
      file { "/etc/init/${name}.conf":
        ensure  => present,
        content => template("spraints/etc/init/${name}.conf.erb"),
        owner   => "root",
        mode    => "444",
      }
    } else {
      $rcfile = "/etc/init.d/${name}"

      file { $rcfile:
        ensure  => present,
        content => template("spraints/etc/init.d/${name}-ubuntu.erb"),
        notify  => Exec["updaterc ${rcfile}"],
        mode    => "755",
      }

      exec { "updaterc ${rcfile}":
        command     => "/usr/sbin/update-rc.d ${name} defaults",
        path        => "/usr/sbin:/usr/bin:/sbin/:/bin",
        refreshonly => true,
      }
    }
  }
}
