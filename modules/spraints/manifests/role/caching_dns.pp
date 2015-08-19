# Loosely based on https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-caching-or-forwarding-dns-server-on-ubuntu-14-04
class spraints::role::caching_dns(
  $upstream = "8.8.8.8",
) {

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
