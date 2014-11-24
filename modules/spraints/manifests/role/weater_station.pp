class spraints::role::weather_station {
  include spraints::app::fowsr

  include spraints::services::collectd

  # todo - fowsr + collectd
  # todo - fowsr + wunderground (KINPICKA2)
}
