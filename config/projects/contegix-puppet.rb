name "contegix-puppet"
maintainer "Contegix LLC"
homepage "http://www.contegix.com"

replaces        "contegix-puppet"
install_dir    "/opt/contegix/puppet"
#build_version   Omnibus::BuildVersion.new.semver
build_version   "3.6.2"
build_iteration 3

# creates required build directories
dependency "preparation"

# puppet dependencies/components
override :ruby, version: "2.1.3"
dependency "git"
dependency "ruby"
dependency "puppet"

config_file "#{install_dir}/etc/puppet/puppet.conf"
config_file "#{install_dir}/etc/sysconfig/puppet"
config_file "#{install_dir}/etc/sysconfig/puppetmaster"

# version manifest file
dependency "version-manifest"

exclude "**/.git"
exclude "**/bundler/git"
