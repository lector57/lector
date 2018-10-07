#!/bin/bash

IF_CFG1_FILE=/etc/sysconfig/network-scripts/ifcfg-enp0s3
IF_CFG2_FILE=/etc/sysconfig/network-scripts/ifcfg-enp0s8
SYSCTL_FILE=/etc/sysct.conf

echo "TYPE=Ethernet" > $IF_CFG1_FILE
echo "BOOTPROTO=dhcp" >> $IF_CFG1_FILE
echo "DEFROUTE=yes" >> $IF_CFG1_FILE
echo "PEERDNS=yes" >> $IF_CFG1_FILE
echo "PEERROUTES=yes" >> $IF_CFG1_FILE
echo "NAME=enp0s3" >> $IF_CFG1_FILE
echo "DEVICE=enp0s3" >> $IF_CFG1_FILE
echo "ONBOOT=yes" >> $IF_CFG1_FILE


echo "TYPE=Ethernet" > $IF_CFG2_FILE
echo "BOOTPROTO=none" >> $IF_CFG2_FILE
echo "IPADDR=192.168.56.2" >> $IF_CFG2_FILE
echo "NETMASK=255.255.255.0" >> $IF_CFG2_FILE
echo "NAME=enp0s8" >> $IF_CFG2_FILE
echo "DEVICE=enp0s8" >> $IF_CFG2_FILE
echo "ONBOOT=yes" >> $IF_CFG2_FILE

/etc/init.d/network restart

echo "net.ipv6.conf.all.disable_ipv6 = 1" > $SYSCTL_FILE
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> $SYSCTL_FILE
echo "net.ipv4.ip_forward = 1" >> $SYSCTL_FILE

sysctl -p

/bin/hostnamectl set-hostname VM1.local


export IPT="iptables"

# Внешний интерфейс
export WAN=enp0s3

# Локальная сеть
export LAN1=enp0s8
export LAN1_IP_RANGE=192.168.56.3/32

# Очищаем правила
$IPT -F
$IPT -F -t nat
$IPT -F -t mangle
$IPT -X
$IPT -t nat -X
$IPT -t mangle -X

# Запрещаем все, что не разрешено
$IPT -P INPUT DROP
$IPT -P OUTPUT DROP
$IPT -P FORWARD DROP

# Разрешаем localhost и локалку
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A INPUT -i $LAN1 -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT
$IPT -A OUTPUT -o $LAN1 -j ACCEPT

# Рзрешаем пинги
$IPT -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
$IPT -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Разрешаем исходящие подключения сервера
$IPT -A OUTPUT -o $WAN -j ACCEPT
#$IPT -A INPUT -i $WAN -j ACCEPT

# разрешаем установленные подключения
$IPT -A INPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A OUTPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -A FORWARD -p all -m state --state ESTABLISHED,RELATED -j ACCEPT

# Отбрасываем неопознанные пакеты
$IPT -A INPUT -m state --state INVALID -j DROP
$IPT -A FORWARD -m state --state INVALID -j DROP

# Отбрасываем нулевые пакеты
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# Закрываемся от syn-flood атак
$IPT -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
$IPT -A OUTPUT -p tcp ! --syn -m state --state NEW -j DROP


# Разрешаем доступ из локалки наружу
$IPT -A FORWARD -i $LAN1 -o $WAN -j ACCEPT
# Закрываем доступ снаружи в локалку
$IPT -A FORWARD -i $WAN -o $LAN1 -j REJECT


# Включаем NAT
$IPT -t nat -A POSTROUTING -o $WAN -s $LAN1_IP_RANGE -j MASQUERADE


# Сохраняем правила, перегружаем сервис
/sbin/iptables-save  > /etc/sysconfig/iptables
/usr/libexec/iptables/iptables.init save

