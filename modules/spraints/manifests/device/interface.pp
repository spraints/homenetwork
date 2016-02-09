define spraints::device::interface(
  $interface = $name,
  $mode      = undef
) {
  if $::operatingsystem == "OpenBSD" {
    if $mode == undef {
      file { "/etc/hostname.${interface}":
        ensure  => absent,
      }
    } else {
      file { "/etc/hostname.${interface}":
        ensure  => present,
        owner   => "root",
        mode    => "444",
        content => $mode,
        notify  => Exec["restart ${interface}"],
      }

      exec { "restart ${interface}":
        command => "sh /etc/netstart ${interface}",
        path    => "/bin:/usr/bin:/sbin:/usr/sbin",
        user    => "root",
      }
    }
  }
}
