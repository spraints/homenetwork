class spraints::role::att_wireless(
  $router_ip = "192.168.0.1",
  $login = "attadmin",
) {
  include spraints::services::collectd

  file { "/etc/collectd/collectd.conf.d/att_wireless.conf":
    ensure => present,
    mode   => 644,
    owner  => "root",
    source => "puppet:///modules/spraints/etc/collectd/collectd.conf.d/att_wireless.conf",
    notify => Service["collectd"],
  }

  file { "/opt/collectd/att_wireless":
    ensure => present,
    owner  => "root",
    source => "puppet:///modules/spraints/opt/collectd/att_wireless",
    mode   => "555",
    require => [
      File["/opt/collectd"],
      Package["jq"],
    ],
    notify => Service["collectd"],
  }

  file { "/opt/collectd":
    ensure => directory,
    owner  => "root",
    mode   => 644,
  }

  package { "jq":
    ensure => installed,
  }

  #####

  include spraints::services::visage

  file { "/var/local/visage/profiles.yaml.d/att_wireless.yaml":
    ensure => present,
    owner => "visage",
    group => "visage",
    mode => 644,
    content => template("spraints/var/local/visage/profiles.yaml.d/att_wireless.yaml.erb"),
    notify => Exec["build visage profile"],
  }
}
