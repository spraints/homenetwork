node /^minibuntu/ {
  include spraints::basenode

  include spraints::role::network_monitor
  include spraints::role::weather_station
  include spraints::role::caching_dns
  include spraints::role::monitor_zig_or_att

  include spraints::role::att_wireless_tombstone
}
