#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "augeas"
default_version "1.1.0"

dependency "libxml2"
dependency "libxslt"
dependency "readline"

source :url => "http://download.augeas.net/augeas-#{version}.tar.gz",
       :md5 => "520ce983457ff9ffa3816bc41a9f328b"

relative_path "augeas-#{version}"

configure_env =
  case platform
  when "aix"
    {
      "LDFLAGS" => "-maix64 -L#{install_dir}/embedded/lib -Wl,-blibpath:#{install_dir}/embedded/lib:/usr/lib:/lib",
      "CFLAGS" => "-maix64 -I#{install_dir}/embedded/include",
      "LD" => "ld -b64",
      "OBJECT_MODE" => "64",
      "ARFLAGS" => "-X64 cru "
    }
  when "mac_os_x"
    {
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib"
    }
  when "solaris2"
    if Omnibus.config.solaris_compiler == "studio"
    {
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -DNO_VIZ"
    }
    elsif Omnibus.config.solaris_compiler == "gcc"
    {
      "LDFLAGS" => "-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib -DNO_VIZ"
    }
    else
      raise "Sorry, #{Omnibus.config.solaris_compiler} is not a valid compiler selection."
    end
  else
    {
      #"LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -Wl,--start-group -Wl,-L#{install_dir}/embedded/lib -Wl,-lxml2 -Wl,-lz -Wl,--end-group",
      #"LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -Wl,-L#{install_dir}/embedded/lib -Wl,-lxml2 -Wl,--exclude-libs=/usr/lib64/libxml2.so.2 -Wl,--exclude-libs=/lib64/libz.so.1",
      "LDFLAGS" => "-Wl,-R#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -lxml2 -lz",
      "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib",
      "LIBXML_LIBS" => "-L#{install_dir}/embedded/lib",
      "LIBXML_CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include/libxml2",
      "PKG_CONFIG_PATH" => "#{install_dir}/embedded/lib/pkgconfig"
    }
  end

build do
  patch :source => "augeas-1.1.0-grub-setkey.patch", 			:plevel => 1
  patch :source => "augeas-1.1.0-incl-double-slash.patch", 		:plevel => 1
  patch :source => "augeas-1.1.0-sysconfig-comments.patch", 		:plevel => 1
  patch :source => "augeas-1.1.0-testPermsErrorReported-root.patch", 	:plevel => 1
  patch :source => "augeas-1.1.0-shellvars-multi-export.patch", 	:plevel => 1
  patch :source => "augeas-1.1.0-cve-2013-6412-umask.patch", 		:plevel => 1
  patch :source => "augeas-1.1.0-yum-cron.patch", 			:plevel => 1
  patch :source => "augeas-1.1.0-shellvars-firewalld.patch", 		:plevel => 1
  patch :source => "augeas-1.1.0-grub-foreground.patch", 		:plevel => 1
  patch :source => "augeas-1.1.0-yum-equals-space.patch", 		:plevel => 1
  patch :source => "augeas-1.1.0-shellvars-case-semicolons.patch", 	:plevel => 1
  patch :source => "augeas-1.1.0-iproute2-dsfield-hex.patch", 		:plevel => 1
  patch :source => "augeas-1.1.0-iproute2-protos-slash.patch", 		:plevel => 1
  patch :source => "augeas-1.1.0-yum-exclude.patch", 			:plevel => 1
  patch :source => "augeas-1.1.0-dovecot-mailbox.patch", 		:plevel => 1
  patch :source => "augeas-1.1.0-keepalived-virtual-servers.patch", 	:plevel => 1
  patch :source => "augeas-1.1.0-krb5-braces.patch", 			:plevel => 1

  

  command "./configure --prefix=#{install_dir}/embedded --without-selinux" , :env => configure_env
  command "make " , :env => configure_env
  command "make install" , :env => configure_env
end
