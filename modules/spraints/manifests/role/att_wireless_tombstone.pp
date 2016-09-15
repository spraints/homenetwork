class spraints::role::att_wireless_tombstone {
  file { "/etc/collectd/collectd.conf.d/att_wireless.conf":
    ensure => absent,
    notify => Service["collectd"],
  }

  file { "/opt/collectd/att_wireless":
    ensure => absent,
    notify => Service["collectd"],
  }

  file { "/var/local/visage/profiles.yaml.d/att_wireless.yaml":
    ensure => absent,
    notify => Exec["build visage profile"],
  }
}
