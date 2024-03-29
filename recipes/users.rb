#
# Cookbook Name:: pgbarman
# Recipe:: users
#
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "sudo"
include_recipe "mail_alias"

pgbarman_user = "barman"

unless Chef::Config[:solo]

  ssh_keys = data_bag_item("users", "barman")['ssh_keys']
  barman_users = search(:users, "groups:barman").map{|u| u.id }
  top_level_domain =  node['domain'].split('.')[-2..-1].join('.')
  barman_users = barman_users.map {|u| "#{u}@#{top_level_domain}" }
  
  directory "/home/barman/.ssh" do
    owner "barman"
    group "barman"
    mode "0700"
  end

  template "/home/barman/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    variables :ssh_keys => ssh_keys
    owner "barman"
    group "barman"
    mode "0600"
  end
  
  users_manage_noid pgbarman_user do
    action [ :remove, :create ]
  end

  mail_alias "barman" do
    recipients barman_users
  end
  
end

if Chef::Config[:solo]
  # give vagrant back sudo permissions if running w/ vagrant
  require 'etc'
  begin
    pwent = Etc.getpwnam "vagrant"
    if pwent
      sudo "vagrant" do
        user "vagrant"
        commands ["ALL"]
        nopasswd true
      end
    end
  rescue ArgumentError
    Chef::Log.debug("Not creating new sudoers entry for vagrant user as we are not running under Vagrant")
  end
end

# add sudoers
sudo pgbarman_user do
  template "app.erb"
  variables(
            {
              "name" => pgbarman_user,
              "service" => pgbarman_user
            }
            )
end
