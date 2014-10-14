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

name "readline"
default_version "6.2"

source :url => "ftp://ftp.cwru.edu/pub/bash/readline-#{version}.tar.gz",
       :md5 => "67948acb2ca081f23359d0256e9a271c"

relative_path "readline-#{version}"

configure_env =
  case Ohai['platform']
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
      "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -Wl,-L#{install_dir}/embedded/lib",
      "CFLAGS" => "-I#{install_dir}/embedded/include -L#{install_dir}/embedded/lib",
      "LIBXML_LIBS" => "-L#{install_dir}/embedded/lib",
      "LIBXML_CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include/libxml2",
      "PKG_CONFIG_PATH" => "#{install_dir}/embedded/lib/pkgconfig"
    }
  end

build do
  patch :source => "readline62-001.patch" , :plevel => 0
  patch :source => "readline62-002.patch" , :plevel => 0
  patch :source => "readline62-003.patch" , :plevel => 0
  patch :source => "readline62-004.patch" , :plevel => 0
  patch :source => "readline62-005.patch" , :plevel => 0
  command "./configure --prefix=#{install_dir}/embedded" , :env => configure_env
  command "make " , :env => configure_env
  command "make install" , :env => configure_env
end
