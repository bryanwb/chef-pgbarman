#
# Cookbook Name:: pgbarman
# Recipe:: default
#
# Copyright (C) 2012 UN FAO
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "yum::epel"
include_recipe "yumrepo::postgresql"
include_recipe "postgresql::client"
include_recipe "ark"

user "barman"

  
%w{ python-psycopg2 python-dateutil python-argparse }.each do |pkg|
  package pkg
end

remote_file "#{Chef::Config[:file_cache_path]}/python_argh.rpm" do
  source "http://downloads.sourceforge.net/project/pgbarman/rhel6-deps/python-argh-0.15.0-1.rhel6.noarch.rpm?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpgbarman%2Ffiles%2Frhel6-deps%2F&ts=1350467056&use_mirror=ignum"
  checksum "d25da0eb2cd9bb9e99d162091e69d7cf38a1e1fab06d722c2537ccf37fb5c15d"
end

rpm_package "python-argh" do
  source "#{Chef::Config[:file_cache_path]}/python_argh.rpm"
end

%w{ /usr/local/barman /var/log/barman }.each do |dir|
  directory dir do
    owner "barman"
    group "barman"
    mode "0775"
  end
end

ark "pgbarman" do
  version "1.1.0"
  url "http://downloads.sourceforge.net/project/pgbarman/1.1.0/barman-1.1.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpgbarman%2F&ts=1350464235&use_mirror=freefr"
  checksum "ab176c1aea199c2a8314c781dcd5f733f513f0334e2f90f6dfbc3caf294c641e"
  creates "/usr/bin/barman"
  action [ :setup_py_build, :setup_py_install ]
end

template "/etc/barman.conf" do
  group "barman"
  source "barman.conf.erb"
  mode "0775"
  action :create_if_missing
#  notifies :action, "service[barman]"
end
