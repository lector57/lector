# Cookbook:: task10
# Recipe:: default

template '/tmp/docker_up.sh' do
  source 'docker.erb'
  mode '0744'
  owner 'root'
  group 'root'
end


template '/tmp/metadata.pl' do
  source 'metadata.erb'
  mode '0744'
  owner 'root'
  group 'root'
end

template '/tmp/environment.pl' do
  source 'environment.erb'
  mode '0744'
  owner 'root'
  group 'root'
end

puts #{node["docker"]["version"]}

bash '/tmp/metadata' do
  user 'root'
  cwd '/tmp'
  code '/tmp/metadata.pl'
end


bash 'docker_up' do
  user 'root'
  cwd '/tmp'
  code '/tmp/docker_up.sh'
end


bash 'environment' do
  user 'root'
  cwd '/tmp'
  code '/tmp/environment.sh'
end
