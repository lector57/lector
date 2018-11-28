# # encoding: utf-8

# Inspec test for recipe task9::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('docker') do
  it { should be_installed }
  
end

describe file('/etc/docker/daemon.json') do
  its('content') { should eq "{ insecure-registries : [ip_address:5000] }\n" }
end
  
