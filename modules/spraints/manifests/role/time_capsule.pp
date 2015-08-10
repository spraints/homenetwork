# Run as a NAS, with support for being a Time Machine target.
class spraints::role::time_capsule {
  # https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=set%20up%20ubuntu%20as%20a%20timemachine%20target
  include spraints::services::netatalk
  include spraints::mdns

  user { "timecapsule":
    ensure => present,
    gid => "timecapsule",
    password => "$1$zKWC7Xd0$MA3ihzXzWtjX4RTNxeY8Y.", # "timecapsule"
    require => Group["timecapsule"] }

  group { "timecapsule":
    ensure => present }

  file { "/var/time-capsule":
    ensure => directory,
    owner => "timecapsule",
    group => "timecapsule" }

  file { "/etc/netatalk/afpd.conf":
    ensure => present,
    source => "puppet:///modules/spraints/etc/netatalk/afpd.conf" }

  file { "/etc/netatalk/AppleVolumes.default":
    ensure => present,
    source => "puppet:///modules/spraints/etc/netatalk/AppleVolumes.default" }

  file { "/etc/avahi/services/afpd.service":
    ensure => present,
    source => "puppet:///modules/spraints/etc/avahi/services/afpd.service" }
}
