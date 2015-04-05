class spraints::basenode {
  include spraints::est
  include spraints::services::ntp
  include spraints::mdns

  file { "/etc/hosts":
    ensure => present,
    mode => 644,
    owner => root,
    group => root,
    source => "puppet:///modules/spraints/etc/hosts",
  }
}
