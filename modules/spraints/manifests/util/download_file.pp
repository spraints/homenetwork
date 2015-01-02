define spraints::util::download_file($url = "", $cwd = "") {
  exec { $name:
    command => "curl -L -o \"${name}.tmp\" \"${url}\" && mv \"${name}.tmp\" \"${name}\"",
    cwd => $cwd,
    creates => "${cwd}/${name}",
  }
}
