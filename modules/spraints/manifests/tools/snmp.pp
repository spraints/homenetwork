class spraints::tools::snmp {
  package {
    "snmp":
      ensure => "installed";
    "snmp-mibs-downloader":
      ensure => "installed";
  }
}
