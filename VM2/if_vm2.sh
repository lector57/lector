#!/bin/bash

IF_CFG1_FILE=/etc/sysconfig/network-scripts/ifcfg-enp0s3
IF_CFG2_FILE=/etc/sysconfig/network-scripts/ifcfg-enp0s8

echo "TYPE=Ethernet" > $IF_CFG1_FILE
echo "BOOTPROTO=none" >> $IF_CFG1_FILE
echo "GATEWAY=192.168.56.2" >> $IF_CFG1_FILE
echo "DNS1=8.8.8.8" >> $IF_CFG1_FILE
echo "DNS2=4.4.4.4" >> $IF_CFG1_FILE
echo "IPADDR=192.168.56.3" >> $IF_CFG1_FILE
echo "NETMASK=255.255.255.0" >> $IF_CFG1_FILE
echo "DEFROUTE=yes" >> $IF_CFG1_FILE
echo "PEERDNS=yes" >> $IF_CFG1_FILE
echo "PEERROUTES=yes" >> $IF_CFG1_FILE
echo "NAME=enp0s3" >> $IF_CFG1_FILE
echo "DEVICE=enp0s3" >> $IF_CFG1_FILE
echo "ONBOOT=yes" >> $IF_CFG1_FILE


echo "TYPE=Ethernet" > $IF_CFG2_FILE
echo "BOOTPROTO=none" >> $IF_CFG2_FILE
echo "NAME=enp0s8" >> $IF_CFG2_FILE
echo "DEVICE=enp0s8" >> $IF_CFG2_FILE
echo "ONBOOT=no" >> $IF_CFG2_FILE

/etc/init.d/network restart
/bin/hostnamectl set-hostname vm2.local