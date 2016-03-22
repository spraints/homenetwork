class spraints::role::sprouter_config {
  vcsrepo { "/opt/sprouter_config":
    ensure   => present,
    provider => git,
    user     => "root",
    source   => "https://github.com/spraints/sprouter-configurer",
    revision => "2ddde99c4397c51901005e80122ba8e7e850209a",
  }

  $exec_path = "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin"

  exec { "bundle sprouter_config":
    command     => "/usr/bin/env bundle install --binstubs bin --path vendor/gems --without development:test",
    path        => $exec_path,
    cwd         => "/opt/sprouter_config",
    subscribe   => Vcsrepo["/opt/sprouter_config"],
    notify      => Exec["start sprouter_config"],
    refreshonly => true,
  }

  if $::operatingsystem == "OpenBSD" {
    file { "/etc/rc.d/sprouter_config":
      ensure  => present,
      owner   => "root",
      mode    => "555",
      content => template("spraints/etc/rc.d/sprouter_config.erb"),
      notify  => Exec["start sprouter_config"],
    }

    exec { "start sprouter_config":
      command     => "rcctl enable sprouter_config && rcctl stop sprouter_config && rcctl start sprouter_config",
      path        => $exec_path,
      user        => "root",
      require     => [ Exec["bundle sprouter_config"], File["/etc/rc.d/sprouter_config"] ],
      refreshonly => true,
    }
  } else {
    # todo
  }
}
