class spraints::role::att_wireless(
  $router_ip = "192.168.0.1",
  $login = "attadmin",
) {
  include spraints::services::collectd

  file { "/etc/collectd/collectd.conf.d/att_wireless.conf":
    ensure => present,
    owner => "root",
    group => "root",
    source => "puppet:///modules/spraints/etc/collectd.collectd.conf.d/att_wireless.conf",
  }

  file { "/opt/collectd/att_wirless":
    ensure => present,
    owner => "root",
    group => "root",
    source => "puppet:///modules/spraints/opt/collectd/att_wireless",
    mode => "0555",
    require => [
      File["/opt/collectd"],
      Package["jq"],
    ]
  }

  file { "/opt/collectd":
    ensure => directory,
    owner => "root",
    group => "root",
  }

  package { "jq":
    ensure => installed,
  }
}
