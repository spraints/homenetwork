node /^minibuntu/ {
  include spraints::basenode

  spraints::role::collectd_master { $::hostname: }
}
