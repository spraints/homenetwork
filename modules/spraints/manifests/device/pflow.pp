define spraints::device::pflow(
  $interface  => $name,
  $flowdst    => undef,
  $flowsrc    => undef,
  $pflowproto => "10",
) {
  if $flowdst == undef or $flowsrc == undef {
    file { "/etc/hostname.${interface}":
      ensure  => absent,
    }
  } else {
    file { "/etc/hostname.${interface}":
      ensure  => present,
      owner   => "root",
      mode    => "440",
      content => "flowsrc ${flowsrc} flowdst ${flowdst} pflowproto ${pflowproto}",
    }
  }
}
