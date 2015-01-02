class spraints::role::timecapsule {
  package { ["avahi", "netatalk", "samba"]: ensure => installed }
}
