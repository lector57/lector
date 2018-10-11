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
    echo PubkeyAuthentication yes >> /etc/ssh/sshd_config
  case  $HOSTNAME in
    server1)
    echo 192.168.0.11 server2 >> /etc/hosts
    yum install -y git
    cd /home/vagrant
    git clone https://github.com/lector57/lector.git
    git branch task2
    cat Vagrantfile
    chown -R vagrant:wheel /home/vagrant/lector
  ;;
    server2)
    echo 192.168.0.10 server1 >> /etc/hosts
  ;;
  esac
  /vagrant/ssh_key.sh
  SHELL
end
