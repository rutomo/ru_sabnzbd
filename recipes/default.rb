#
# Cookbook Name:: ru_sabnzbd
# Recipe:: default
#
# Copyright 2016, Rinaldi Utomo
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
admin_user = search(:sabnzbd,'id:admin').first
home_dir = ::File.join("/home", admin_user['username'])
sabnzbd_dir = ::File.join(home_dir, '.sabnzbd')

smb_val = search(:sabnzbd,'id:smb').first
network_val = search(:sabnzbd,'id:network').first
sabnzbd_settings = search(:sabnzbd,'id:data_bag_item_sabnzbd_settings').first
package 'software-properties-common'

admin 'admin' do
  username admin_user['username']
  public_keys admin_user['public_keys']
  action :create
end

smb 'smb' do
  smb_username smb_val['smb_username']
  smb_password smb_val['smb_password']
  mount_network_drive smb_val['mount_network_drive']
  mount_name smb_val['mount_name']
  username admin_user['username']
end

directory sabnzbd_dir do
   recursive true
   mode '0755'
   user admin_user['username']
 	 group admin_user['username']
end

bash 'add_external_repo' do
  user "root"
  cwd "root"
  code <<-EOF
    add-apt-repository ppa:jcfp/ppa
    add-apt-repository ppa:jcfp/nobetas
    apt-get update
    apt-get -y install sabnzbdplus
    EOF
end
template "/etc/default/sabnzbdplus" do
  source "sabnzbdplus.erb"
  mode "0644"
  owner "root"
  group "root"
  variables({
      :username => admin_user['username'],
      :home_dir => home_dir
  })
end
template ::File.join(sabnzbd_dir,'sabnzbd.ini') do
  source 'sabnzbd.erb'
  mode '0755'
  owner admin_user['username']
  group admin_user['username']
  variables({
      :cleanup_list => sabnzbd_settings['cleanup_list'],
      :api_key => sabnzbd_settings['api_key'],
      :dirscan_dir => "/mnt/#{smb_val['mount_name']}",
      :password => sabnzbd_settings['password'],
      :port => sabnzbd_settings['port'],
      :host => sabnzbd_settings['host'],
      :download_dir => "/mnt/#{smb_val['mount_name']}/Downloads/Incomplete",
      :complete_dir => "/mnt/#{smb_val['mount_name']}/Downloads/complete",
      :servers => sabnzbd_settings['servers'],
      :categories => sabnzbd_settings['categories']
  })
end

service "sabnzbdplus" do
  action :start
end
