Vagrant.configure("2") do |config|

  config.vm.box = "bento/centos-7.5"
  config.vm.box_check_update = false
  
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "1024"
  end
  
  config.vm.define "server1" do |server1|
    server1.vm.hostname = "server1"
    server1.vm.network "private_network", ip: "192.168.0.10"
  end

  config.vm.define "server2" do |server2|
     server2.vm.hostname = "server2"
     server2.vm.network "private_network", ip: "192.168.0.11"
  end

  config.vm.provision "shell", inline: <<-SHELL
    if [ $HOSTNAME == "server1" ]; then
    yum install -y git
    fi
  SHELL
  
end