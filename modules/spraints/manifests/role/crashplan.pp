class spraints::role::crashplan {
  download_file {
    "CrashPlan_3.6.4_Linux.tgz":
      url => "http://download1.us.code42.com/installs/linux/install/CrashPlan/CrashPlan_3.6.4_Linux.tgz",
      cwd => "/var/local/homenetwork-puppet/downloads",
  }
  # Download http://download1.us.code42.com/installs/linux/install/CrashPlan/CrashPlan_3.6.4_Linux.tgz
  # Install it.
  # Configure it.
  # Mount a disk?
}
