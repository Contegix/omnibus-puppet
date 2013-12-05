
name "contegix-puppet"
maintainer "Contegix LLC"
homepage "http://www.contegix.com"

replaces        "contegix-puppet"
install_path    "/opt/contegix/puppet"
#build_version   Omnibus::BuildVersion.new.semver
build_version   "3.3.2"
build_iteration 13

# creates required build directories
dependency "preparation"

# puppet dependencies/components
dependency "ruby"
dependency "puppet"

config_file "#{install_path}/etc/puppet/puppet.conf"
config_file "#{install_path}/etc/sysconfig/puppet"
config_file "#{install_path}/etc/sysconfig/puppetmaster"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
