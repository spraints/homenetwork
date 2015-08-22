define spraints::util::download_file($url = "", $cwd = "") {
  exec { $name:
    command => "/usr/bin/curl -L -o \"${name}.tmp\" \"${url}\" && /bin/mv \"${name}.tmp\" \"${name}\"",
    cwd => $cwd,
    creates => "${cwd}/${name}",
  }
}
