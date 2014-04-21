# -*- mode: ruby -*-
# vi: set ft=ruby :

require "vagrant"

if Vagrant::VERSION < "1.2.1"
  raise "The Omnibus Build Lab is only compatible with Vagrant 1.2.1+"
end

host_project_path = File.expand_path("..", __FILE__)
guest_project_path = "/home/vagrant/#{File.basename(host_project_path)}"
project_name = "contegix-puppet"

Vagrant.configure("2") do |config|

  config.vm.hostname = "#{project_name}.build.contegix.com"

  config.vm.define 'centos-5' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "opscode-centos-5.8"
    c.vm.box_url = "http://opscode-vm.s3.amazonaws.com/vagrant/opscode_centos-5.9_chef-11.4.4.box"
  end

  config.vm.define 'centos-5_32' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "opscode-centos-5.8_32"
    c.vm.box_url = "http://opscode-vm.s3.amazonaws.com/vagrant/opscode_centos-5.9-i386_chef-11.4.4.box"
  end

  config.vm.define 'centos-6' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "opscode-centos-6.4"
    c.vm.box_url = "http://opscode-vm.s3.amazonaws.com/vagrant/opscode_centos-6.4_chef-11.4.4.box"
  end

  config.vm.define 'centos-6_32' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "opscode-centos-6.4_32"
    c.vm.box_url = "http://opscode-vm.s3.amazonaws.com/vagrant/opscode_centos-6.4-i386_chef-11.4.4.box"
  end

  config.vm.define 'ubuntu-12.04_64' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "canonical-ubuntu-12.04"
    c.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
  end

  config.vm.define 'ubuntu-14.04_64' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "canonical-ubuntu-12.04"
    c.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  end

  config.vm.provider :virtualbox do |vb|
    # Give enough horsepower to build without taking all day.
    vb.customize [
      "modifyvm", :id,
      "--memory", "2048",
      "--cpus", "2"
    ]
    vb.customize [
      "modifyvm", :id,
      "--natdnshostresolver1", "on"
    ]
    vb.customize [
      "modifyvm", :id,
      "--natdnsproxy1", "on"
    ]
  end

  # Ensure a recent version of the Chef Omnibus packages are installed
  config.omnibus.chef_version = :latest

  # Enable the berkshelf-vagrant plugin
  config.berkshelf.enabled = true
  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"

#  config.ssh.max_tries = 40
#  config.ssh.timeout   = 120
  config.ssh.forward_agent = true

  host_project_path = File.expand_path("..", __FILE__)
  guest_project_path = "/home/vagrant/#{File.basename(host_project_path)}"

  config.vm.synced_folder host_project_path, guest_project_path

  # prepare VM to be an Omnibus builder
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      "omnibus" => {
        "build_user" => "vagrant",
        "build_dir" => guest_project_path,
        "install_dir" => "/opt/contegix/puppet"
      }
    }

    chef.run_list = [
      "recipe[omnibus::default]"
    ]
  end

  config.vm.provision :shell, :inline => <<-OMNIBUS_BUILD
    export PATH=/usr/local/bin:$PATH
    cd #{guest_project_path}
    su vagrant -c "bundle install --binstubs"
    su vagrant -c "bin/omnibus build project #{project_name}"
  OMNIBUS_BUILD
end
