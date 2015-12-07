# The old production computer from church.
node /^tower-of-backups(\.|$)/ {
  include spraints::basenode

  include spraints::role::network_monitor
  include spraints::role::time_capsule
}
