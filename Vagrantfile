Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "1024"
  end
  
  config.vm.define "server1" do |server1|
     server1.vm.hostname = "server1"
     server1.vm.network "private_network", ip: "192.168.0.10"
     config.vm.provision "shell", inline: "yum install git -y"
  end

  config.vm.define "server2" do |server2|
     server2.vm.hostname = "server2"
     server2.vm.network "private_network", ip: "192.168.0.11"
     config.vm.provision "shell", inline: echo "do not install anything"
  end

end