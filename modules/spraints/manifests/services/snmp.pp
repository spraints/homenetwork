class spraints::services::snmp {
  package {
    "snmp":
      ensure => "installed";
    "snmp-mibs-downloader"
      ensure => "installed";
  }
}
