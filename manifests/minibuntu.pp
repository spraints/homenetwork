node /^minibuntu/ {
  include spraints::basenode

  include spraints::role::network_monitor
  include spraints::role::weather_station
  include spraints::role::timecapsule
}
