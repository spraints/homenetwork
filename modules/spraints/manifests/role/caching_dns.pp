# Loosely based on https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-caching-or-forwarding-dns-server-on-ubuntu-14-04
class spraints::role::caching_dns {

  # Info on cache flushing is here:
  # https://kb.isc.org/article/AA-01002/0/How-do-I-flush-or-delete-incorrect-records-from-my-recursive-server-cache.html
  # tldr - use `rndc`

  package { ["bind9", "bind9utils", "bind9-doc"]:
    ensure => installed
  }

  service { "bind9":
    ensure  => running,
    require => Package["bind9"],
  }

  file { "/etc/bind9/named.conf.options":
    notify  => Service["bind9"],
    mode    => 644,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/etc/bind9/named.conf.options",
  }
}
