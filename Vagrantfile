Vagrant.configure("2") do |config|

  config.vm.box = "bento/centos-7.5"
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = "512"
  end

  config.vm.define "tomcat1" do |tomcat1|
    tomcat1.vm.hostname = "tomcat1"
    tomcat1.vm.network "private_network", ip: "192.168.0.11"
  end

  config.vm.define "tomcat2" do |tomcat2|
    tomcat2.vm.hostname = "tomcat2"
    tomcat2.vm.network "private_network", ip: "192.168.0.12"
  end
  
  config.vm.define "apache" do |apache|
    apache.vm.hostname = "apache"
    apache.vm.network "private_network", ip: "192.168.0.10"
  end
  
  config.vm.provision "shell", inline: <<-SHELL
  systemctl stop firewalld
  case  $HOSTNAME in
  
  apache)
  yum install -y mc httpd
  cp /vagrant/mod_jk.so /etc/httpd/modules/
  file1=/etc/httpd/conf/workers.properties
  file2=/etc/httpd/conf.d/connector.conf	
  echo "worker.list=lb" > $file1
  echo "worker.lb.type=lb" >> $file1
  echo "worker.lb.balance_workers=tomcat1, tomcat2" >> $file1
  echo "worker.tomcat1.host=192.168.0.11" >> $file1
  echo "worker.tomcat1.port=8009" >> $file1
  echo "worker.tomcat1.type=ajp13" >> $file1
  echo "worker.tomcat2.host=192.168.0.12" >> $file1
  echo "worker.tomcat2.port=8009" >> $file1
  echo "worker.tomcat2.type=ajp13" >> $file1
  echo "LoadModule jk_module modules/mod_jk.so" > $file2
  echo "JkWorkersFile conf/workers.properties" >> $file2
  echo "JkShmFile /tmp/shm" >> $file2
  echo "JkLogFile logs/mod_jk.log" >> $file2
  echo "JkLogLevel info" >> $file2
  echo "JkMount /test* lb" >> $file2
  systemctl enable httpd
  systemctl start httpd
  ;;
  
  tomcat1)
  yum install -y tomcat tomcat-webapps tomcat-admin-webappsmc mc
  mkdir /usr/share/tomcat/webapps/test
  echo "TomCat1"> /usr/share/tomcat/webapps/test/index.html
  systemctl enable tomcat
  systemctl start tomcat
  ;;
  
  tomcat2)
  yum install -y tomcat tomcat-webapps tomcat-admin-webappsmc mc
  mkdir /usr/share/tomcat/webapps/test
  echo "TomCat2"> /usr/share/tomcat/webapps/test/index.html
  systemctl enable tomcat
  systemctl start tomcat
  ;;
  esac
  SHELL
end
