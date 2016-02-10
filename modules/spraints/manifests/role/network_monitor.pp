class spraints::role::network_monitor(
  $wifi_hosts = {},
  $airport = false,
  $weather = false,
  $ping_targets = [],
) {
  include spraints::services::collectd

  file { "/etc/default/collectd":
    notify  => Service["collectd"],
    mode    => 644,
    owner   => "root",
    source  => "puppet:///modules/spraints/etc/default/collectd",
  }

  if($airport) {
    file { "/etc/collectd/collectd.conf.d/airport-snmp.conf":
      notify  => Service["collectd"],
      mode    => 644,
      owner   => "root",
      source  => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/airport-snmp.conf",
      require => [
        Package["snmp-mibs-downloader"],
        File["/usr/share/snmp/mibs/AIRPORT-BASESTATION-3-MIB.txt"],
      ],
    }
  }

  file { "/etc/collectd/collectd.conf.d/ping-the-world.conf":
    notify  => Service["collectd"],
    mode    => 644,
    owner   => "root",
    content => template("spraints/etc/collectd/collectd.conf.d/ping-the-world.conf.erb"),
  }

  file { "/etc/collectd/collectd.conf.d/server.conf":
    notify  => Service["collectd"],
    mode    => 644,
    owner   => "root",
    content => template("spraints/etc/collectd/collectd.conf.d/server.conf.erb"),
  }

  #####

  if($airport) {
    include spraints::tools::snmp

    file { "/usr/share/snmp/mibs/AIRPORT-BASESTATION-3-MIB.txt":
      mode    => 644,
      owner   => "root",
      source  => "puppet:///modules/spraints/usr/share/snmp/mibs/AIRPORT-BASESTATION-3-MIB.txt",
    }
  }

  #####

  include spraints::services::visage

  file { "/var/local/visage/profiles.yaml.d/network_monitor.yaml":
    ensure => present,
    owner => "visage",
    group => "visage",
    mode => 644,
    content => template("spraints/var/local/visage/profiles.yaml.d/network_monitor.yaml.erb"),
    notify => Exec["build visage profile"],
  }
}
