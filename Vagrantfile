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
##разрешает ssh подключение с использованием открытого ключа

   yum install -y expect
   /vagrant/ssh_key_generate.exp
   case  $HOSTNAME in
   server1)
   echo 192.168.0.11 server2 >> /etc/hosts
   /vagrant/ssh_id_to_server2
   yum install -y git
   cd /home/vagrant
   git clone https://github.com/lector57/lector.git
   git branch task2
   git pull origin task2
   cat Vagrantfile
   ;;
   server2)
   echo 192.168.0.10 server1 >> /etc/hosts
   /vagrant/ssh_id_to_server1
   ;;
   esac
   SHELL
end
