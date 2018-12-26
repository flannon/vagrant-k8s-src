# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.0.1"

HOSTNAME = "k8s-src"
ANSIBLEROLE = "#{HOSTNAME}"
IPADDR = "172.25.250.254"
CPUS = "4"
MEMORY = "6144"
MULTIVOL = false
MOUNTPOINT = "/mnt"
VAGRANTROOT = File.expand_path(File.dirname(__FILE__))
VAGRANTFILE_API_VERSION = "2"

# Ensure vagrant plugins
required_plugins = %w( vagrant-vbguest vagrant-scp vagrant-share vagrant-persistent-storage vagrant-reload )

required_plugins.each do |plugin|
  exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "centos/7"
  config.ssh.insert_key = false
  config.vm.network :private_network, ip: IPADDR,
    virtualbox__hostonly: true
  config.vm.network :forwarded_port, guest: 80, host: 10080,
    virtualbox__hostonly: true
  config.vm.network :forwarded_port, guest: 443, host: 10443,
    virtualbox__hostonly: true
  config.vm.network :forwarded_port, guest: 8052, host: 10052,
    virtualbox__hostonly: true

  config.vm.provider :virtualbox do |vb|
    vb.name = HOSTNAME
    vb.memory = MEMORY
    vb.cpus = CPUS
    if CPUS != "1"
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.linked_clone = true if Vagrant::VERSION =~ /^1.8/
  end

  config.vm.hostname = HOSTNAME + ".local"
  config.vm.provision :shell, inline: "yum -y install ansible"
  config.vm.provision "file", 
    source: "~/.gitconfig", 
    destination: ".gitconfig"

  # Disable selinux and reboot
  unless FileTest.exist?("#{VAGRANTROOT}/untracked-files/first_boot_complete")
    config.vm.provision :shell, inline: "yum -y update"
    config.vm.provision :shell, inline: "sed -i s/^SELINUX=enforcing/SELINUX=permissive/ /etc/selinux/config"
    config.vm.provision :reload
    #config.vm.synced_folder ".", "/vagrant"
    require 'fileutils'
    FileUtils.touch("#{VAGRANTROOT}/untracked-files/first_boot_complete")
  end

  # Install git and wget
  config.vm.provision :shell, inline: "yum -y install git wget"
  # Load bashrc
  config.vm.provision "file", source: "#{VAGRANTROOT}/files/bashrc", 
     destination: "${HOME}/.bashrc"
  config.vm.provision "file", source: "#{VAGRANTROOT}/files/bashrc", 
    destination: "/home/vagrant/.bashrc"

  # Load ssh keys
  config.vm.provision "file", source: "#{VAGRANTROOT}/files/vagrant", 
    destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision :file, source: "#{VAGRANTROOT}/files/vagrant.pub", 
    destination: "/home/vagrant/.ssh/id_rsa.pub"
  
  # Load /etc/hosts
  config.vm.provision "shell", path: "./bin/hosts.sh", privileged: true
  
  # Set ansible roles environment variable
  # This is unused and may be set wrong, i.e. as currently
  # configured it addresses the host context but it probably should 
  # be the guest context, like the following
  #  ENV['ANSIBLE_ROLES_PATH'] = "#{VAGRANTROOT}/ansible/roles"
  ENV['ANSIBLE_ROLES_PATH'] = "~vagrant/ansible/roles"

  config.vm.define HOSTNAME

  # Run ansible provisioning 
  config.vm.provision :ansible do |ansible|
    ansible.compatibility_mode  = "2.0"
    ansible.verbose = "v"
    ansible.config_file = "#{VAGRANTROOT}/ansible/ansible.cfg"
    ansible.galaxy_roles_path  = "#{VAGRANTROOT}/ansible/roles"
    ansible.galaxy_role_file = "#{VAGRANTROOT}/ansible/requirements.yml"
    ansible.galaxy_command = "ansible-galaxy install --role-file=./ansible/requirements.yml --roles-path=./ansible/roles --force"
    ansible.playbook = "#{VAGRANTROOT}/ansible/playbooks/#{ANSIBLEROLE}.yml"
  end

end
