class spraints::tools::go {
  package { "build-essential":
    ensure => "installed",
  }

  $gopkg = $architecture ? {
    ppc     => "gccgo-go",
    default => "golang-go",
  }
  package { "golang-go":
    name   => $gopkg,
    ensure => "installed",
  }
}
