$N = 2
#N - Quantity of TomCat servers

$script = <<END
  if ! [ -f /vagrant/tomcat_name ]; then
    touch /vagrant/tomcat_name
  fi
  if ! [ -f /vagrant/tomcat_ip ]; then
    touch /vagrant/tomcat_ip
  fi

  echo $1 >> /vagrant/tomcat_ip
  echo $2 >> /vagrant/tomcat_name

  yum install -y tomcat tomcat-webapps tomcat-admin-webappsmc
  mkdir /usr/share/tomcat/webapps/test
  echo $2 > /usr/share/tomcat/webapps/test/index.html
  systemctl enable tomcat
  systemctl start tomcat
END

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.5"  
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |vb|
  vb.gui = true
  vb.memory = "1024"
  end

  (1..$N).each do |i|
  config.vm.define "tomcat#{i}" do |node|
  node.vm.hostname = "tomcat#{i}"
  node.vm.network "private_network", ip: "192.168.0.#{10+i}"
  node.vm.provision "shell" do |s|
  s.inline = $script
  s.args = ["192.168.0.#{10+i}", "tomcat#{i}"] 
  end
  end
  end

  config.vm.define "apache" do |apache|
  apache.vm.hostname = "apache"
  apache.vm.network "private_network", ip: "192.168.0.10"
  config.vm.network "forwarded_port", guest: 80, host: 12000
  apache.vm.provision "shell", inline: <<-SHELL
  yum install -y mc httpd
  cp /vagrant/mod_jk.so /etc/httpd/modules/

  file1=/etc/httpd/conf/workers.properties
  file2=/etc/httpd/conf.d/connector.conf
  file3=/vagrant/tomcat_name
  file4=/vagrant/tomcat_ip

  i=0
  STR1=""
  STR2="worker.lb.balance_workers="
  while read LINE
  do
    STR1+="$LINE "
  if [[ i -ne 0 ]]
    then
    STR2+=" ,$LINE"
  else
    STR2+="$LINE"
  i=$(($i+1))
  fi;
  done < $file3

  IFS=' ' read -ra ADDR <<< $STR1
  echo "worker.list=lb" > $file1
  echo "worker.lb.type=lb" >> $file1
  echo $STR2 >> $file1

  i=0
  while read LINE3
  do
  echo "worker.${ADDR[$i]}.host=$LINE3" >> $file1
  echo "worker.${ADDR[$i]}.port=8009" >> $file1
  echo "worker.${ADDR[$i]}.type=ajp13" >> $file1
  i=$(($i+1))
  done < $file4
  echo "LoadModule jk_module modules/mod_jk.so" > $file2
  echo "JkWorkersFile conf/workers.properties" >> $file2
  echo "JkShmFile /tmp/shm" >> $file2
  echo "JkLogFile logs/mod_jk.log" >> $file2
  echo "JkLogLevel info" >> $file2
  echo "JkMount /test* lb" >> $file2
  systemctl enable httpd
  systemctl start httpd
  rm /vagrant/tomcat_name
  rm /vagrant/tomcat_ip
  SHELL
  end
end
