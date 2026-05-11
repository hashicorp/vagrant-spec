# Copyright IBM Corp. 2013, 2026
# SPDX-License-Identifier: MPL-2.0

source 'https://rubygems.org'
gemspec

if File.exist?(File.expand_path("../../vagrant", __FILE__))
  gem 'vagrant', path: "../vagrant"
else
  gem "vagrant", git: "https://github.com/mitchellh/vagrant.git"
end
