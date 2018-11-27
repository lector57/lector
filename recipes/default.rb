#
# Cookbook:: task9
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

yum_package 'yum-utils'

execute 'yum-config-manager' do
  command 'yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo'
end

yum_package 'docker-ce'

execute 'docker registries-insecure-config' do
  command 'echo { "insecure-registries" : ["ip_address:5000" ] } > /etc/docker/daemon.json'
end

service "docker" do
  action :start
end
