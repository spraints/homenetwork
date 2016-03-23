class spraints::role::sprouter_config(
  $install_dir = "/opt/sprouter_config",
){
  vcsrepo { $install_dir:
    ensure   => present,
    provider => git,
    user     => "root",
    source   => "https://github.com/spraints/sprouter-configurer",
    revision => "a131f868e69ef3a2278d09547225343c0177549c",
  }

  $exec_path = "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin"

  exec { "bundle sprouter_config":
    command     => "/usr/bin/env bundle install --local --path vendor/gems --without development:test",
    unless      => "/usr/bin/env bundle check",
    path        => $exec_path,
    cwd         => $install_dir,
    require     => Vcsrepo[$install_dir],
    notify      => Exec["start sprouter_config"],
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
