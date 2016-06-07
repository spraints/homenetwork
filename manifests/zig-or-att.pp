node /^zig-or-att/ {
  include spraints::basenode

  include spraints::role::router
  include spraints::role::sprouter_config

  # Probably temporary, until another mini is available
  include spraints::role::att_wireless
  include spraints::role::network_monitor
}
