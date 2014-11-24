class spraints::role::weather_station {
  include spraints::app::fowsr

  include spraints::services::collectd

  # todo - fowsr + collectd
  # todo - fowsr + wunderground (KINPICKA2)

  # ruby controller.rb
  # - listen on a socket
  # - run fowsr
  # - foward data to the socket
  #
  # ruby collectd-fowsr.rb
  # - open the socket
  # - write the required data
  #
  # ruby collectd-wunderground.sh
  # - open the socket
  # - every Ns report the last seen values to wunderground.
}
