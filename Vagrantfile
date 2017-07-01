# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.define "router" do |router|
    router.vm.box = "twingly/openbsd-5.8-amd64"
    router.vm.hostname = "router.local"
    # re0
    router.vm.network "public_network", auto_config: false, bridge: todo
    # re1
    router.vm.network "public_network", auto_config: false, bridge: todo
    # re2
    router.vm.network "private_network", auto_config: false
    # re3
    router.vm.network "private_network", auto_config: false
  end

  config.vm.define "minibuntu" do |minibuntu|
    minibuntu.vm.box = "ubuntu/trusty32"
    minibuntu.vm.hostname = "minibuntu.local"
    minibuntu.vm.network "private_network", auto_config: false
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
