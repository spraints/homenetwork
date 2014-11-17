class spraints::basenode {
  include spraints::est
  include spraints::services::ntp

  file { "/etc/hosts":
    ensure => present,
    mode => 644,
    source => "puppet:///modules/spraints/etc/hosts",
  }
}
