class spraints::role::network_monitor {
  include spraints::services::collectd

  file { "/etc/collectd/collectd.conf.d/airport-snmp.conf":
    notify  => Service["collectd"],
    mode    => 644,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/airport-snmp.conf",
    require => [
      Package["snmp-mibs-downloader"],
      File["/usr/share/snmp/mibs/AIRPORT-BASESTATION-3-MIB.txt"],
    ],
  }

  file { "/etc/collectd/collectd.conf.d/ping-the-world.conf":
    notify  => Service["collectd"],
    mode    => 644,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/ping-the-world.conf",
  }

  #####

  include spraints::tools::snmp

  file { "/usr/share/snmp/mibs/AIRPORT-BASESTATION-3-MIB.txt":
    mode    => 644,
    owner   => "root",
    group   => "root",
    source  => "puppet:///modules/spraints/usr/share/snmp/mibs/AIRPORT-BASESTATION-3-MIB.txt",
  }

  #####

  include spraints::services::visage

  file { "${visage_config_path}/profiles.yaml":
    ensure => present,
    owner => "visage",
    group => "visage",
    mode => 644,
    source => "puppet:///modules/spraints/var/local/visage/profiles.yaml",
  }
}
