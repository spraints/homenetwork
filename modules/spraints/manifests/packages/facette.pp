class spraints::packages::facette {
  include spraints::tools::go

  exec { "build and install facette":
    command => "/usr/bin/make PREFIX=/opt/facette install",
    creates => "/opt/facette/bin/facette",
    cwd     => "/opt/src/facette",
    require => [
      Class["spraints::tools::go"],
      Package["librrd-dev"],
      Package["pkg-config"],
      Package["npm"],
      Package["pandoc"],
    ],
    subscribe => Vcsrepo["/opt/src/facette"],
  }

  vcsrepo { "/opt/src/facette":
    ensure => present,
    provider => git,
    source => "https://github.com/facette/facette",
    revision => "0.2.1",
  }

  package {
    "librrd-dev":
      ensure => installed;
    "pkg-config":
      ensure => installed;
    "npm":
      ensure => installed;
    "pandoc":
      ensure => installed;
  }
}
