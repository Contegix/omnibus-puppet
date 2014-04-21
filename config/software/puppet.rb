name "puppet"
version "3.4.3"

dependency "ruby"
dependency "rubygems"
dependency "augeas"

env = { "PKG_CONFIG_PATH" => "#{install_dir}/embedded/lib/pkgconfig" }

build do
  
  gem "install json_pure --no-rdoc --no-ri" , :env => env
  gem "install hiera --no-rdoc --no-ri" , :env => env
  gem "install hiera-puppet --no-rdoc --no-ri" , :env => env
  gem "install deep_merge --no-rdoc --no-ri" , :env => env
  gem "install rgen --no-rdoc --no-ri" , :env => env
  gem "install ruby-augeas --no-rdoc --no-ri" , :env => env
  gem "install ruby-shadow --no-rdoc --no-ri" , :env => env
  gem "install gpgme --no-rdoc --no-ri" , :env => env

  # install core project utilities
  gem "install facter -n #{install_dir}/bin --no-rdoc --no-ri -v 1.7.5" , :env => env
  gem "install puppet -n #{install_dir}/bin --no-rdoc --no-ri -v #{version}" , :env => env

  # remove documentation
  command "rm -rf #{install_dir}/embedded/docs"
  command "rm -rf #{install_dir}/embedded/share/man"
  command "rm -rf #{install_dir}/embedded/man"
  command "rm -rf #{install_dir}/embedded/share/doc"
  command "rm -rf #{install_dir}/embedded/ssl/man"
  command "rm -rf #{install_dir}/embedded/info"

  # patch puppet to always use the proper confdir
  command "patch -d #{install_dir} -p0 -i #{Omnibus.project_root}/config/patches/puppet/puppet-00.patch"
  # load default configuration files
  command "rsync -a #{Omnibus.project_root}/files/ #{install_dir}/"

end
