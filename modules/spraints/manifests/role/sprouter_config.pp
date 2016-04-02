class spraints::role::sprouter_config(
  $install_dir = "/opt/sprouter_config",
  $secret_key_base = undef,
){
  vcsrepo { $install_dir:
    ensure   => present,
    provider => git,
    user     => "root",
    source   => "https://github.com/spraints/sprouter-configurer",
    revision => "356bce347a6c07259e386125a24c06a34aa89b92",
    notify   => Exec["start sprouter_config"],
  }

  $exec_path = "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin"

  file { "${install_dir}/run":
    ensure  => present,
    owner   => "root",
    mode    => "555",
    content => template("spraints/opt/sprouter_config/run.sh.erb"),
    notify  => Exec["start sprouter_config"],
    require => Vcsrepo[$install_dir],
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
      require     => [ File["${install_dir}/run"], File["/etc/rc.d/sprouter_config"] ],
      refreshonly => true,
    }
  } else {
    # todo
  }
}
