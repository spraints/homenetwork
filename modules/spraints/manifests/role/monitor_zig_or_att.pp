class spraints::role::zig_or_att {
  # maybe put the collectd server/listen config here?

  include spraints::services::visage

  file { "/var/local/visage/profiles.yaml.d/zig-or-att.yaml":
    ensure => present,
    owner => "visage",
    group => "visage",
    mode => 644,
    content => template("spraints/var/local/visage/profiles.yaml.d/zig-or-att.yaml.erb"),
    notify => Exec["build visage profile"],
  }
}
