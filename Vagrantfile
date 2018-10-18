$TOMCAT_QUANTITY = 3

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.5"  
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "1024"
  end

  (1..$TOMCAT_QUANTITY).each do |i|
  config.vm.define "tomcat#{i}" do |node|
  node.vm.hostname = "tomcat#{i}"
  node.vm.network "private_network", ip: "192.168.0.#{10+i}"
  node.vm.provision "shell" do |s|
    s.path = "tomcat.sh"
    s.args = ["192.168.0.#{10+i}", "tomcat#{i}"] 
  end
  end
  end

  config.vm.define "apache" do |apache|
    apache.vm.hostname = "apache"
    apache.vm.network "private_network", ip: "192.168.0.10"
    apache.vm.network "forwarded_port", guest: 80, host: 18000
    apache.vm.provision "shell", path: "apache.sh"
  end
end
