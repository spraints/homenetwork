define spraints::util::download_file($url = "", $cwd = "", $require = "") {
  exec { "download ${name}":
    command => "curl -L -o \"${name}.tmp\" \"${url}\" && mv \"${name}.tmp\" \"${name}\"",
    cwd => $cwd,
    require => $require,
    creates => "${cwd}/${name}",
  }
}
