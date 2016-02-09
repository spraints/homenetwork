class spraints::basenode($location = "home") {
  include spraints::est
  include spraints::services::ntp
  include spraints::mdns

  file { "/etc/hosts":
    ensure => present,
    mode => 644,
    owner => root,
    content => template("spraints/etc/hosts.erb"),
  }
}
