# A ppc mac mini running ubuntu.
node /^minibuntu/ {
  # base system = 14.04.1

  include spraints::basenode

  include spraints::role::network_monitor
  include spraints::role::weather_station
}
