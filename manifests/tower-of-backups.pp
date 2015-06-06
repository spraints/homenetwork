# The old production computer from church.
node /^tower-of-backups(\.|$)/ {
  include spraints::basenode

  include spraints::role::time_capsule
}
