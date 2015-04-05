# The old production computer from church.
node /^fish-for-bytes\./ {
  include spraints::basenode

  include spraints::role::time_capsule
}
