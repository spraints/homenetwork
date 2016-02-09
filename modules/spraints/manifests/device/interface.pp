define spraints::device::interface(
  $interface = $name,
  $dhcp      = false,
  $address   = undef,
  $netmask   = undef,
  $bcast     = undef,
) {
  if $::operatingsystem == "OpenBSD" {
    if $dhcp == false and $address == undef {

      file { "/etc/hostname.${interface}":
        ensure  => absent,
      }

    } else {

      file { "/etc/hostname.${interface}":
        ensure  => present,
        owner   => "root",
        mode    => "444",
        content => template("spraints/etc/hostname.if.erb"),
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
