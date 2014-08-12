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

name "ubersmithrb"
version "0.0.1"

source :url => "https://github.com/Contegix/ubersmithrb/archive/v#{version}.tar.gz",
       :md5 => "ff26ef9ce03c629e3e77d8584bafd347"

relative_path "ubersmithrb-#{version}"

dependencies ["ruby", "rubygems", "puppet"]

env = { "PKG_CONFIG_PATH" => "#{install_dir}/embedded/lib/pkgconfig" }

build do
  gem "build ./ubersmithrb.gemspec" , :env => env
  gem "install ./ubersmithrb-#{version}.gem" , :env => env
end
