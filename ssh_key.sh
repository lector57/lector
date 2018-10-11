#!/bin/bash

  SSH_DIR="/home/vagrant/.ssh"

  if ! [ -d $SSH_DIR ]; then
    mkdir $SSH_DIR
    chmod 700 $SSH_DIR
    chown  vagrant:vagrant $SSH_DIR
  fi

  if ! [ -f $SSH_DIR/id_rsa ] & [ -f /vagrant/$HOSTNAME/id_rsa ]; then
    cp /vagrant/$HOSTNAME/id_rsa $SSH_DIR
    chmod 600 $SSH_DIR/id_rsa
    chown vagrant:wheel $SSH_DIR/id_rsa
  fi

  if ! [ -f $SSH_DIR/id_rsa.pub ] & [ -f /vagrant/$HOSTNAME/id_rsa.pub ]; then
    cp /vagrant/$HOSTNAME/id_rsa.pub $SSH_DIR
    chmod 600 $SSH_DIR/id_rsa.pub
    chown vagrant:wheel $SSH_DIR/id_rsa.pub
  fi

  case $HOSTNAME in
  server1)
  if [ -f /vagrant/server2/id_rsa.pub ]; then
    cat /vagrant/server2/id_rsa.pub >> $SSH_DIR/authorized_keys
    chmod 644 $SSH_DIR/authorized_keys
    chown vagrant:wheel $SSH_DIR/authorized_keys
  fi
  ;;
  server2)
  if [ -f /vagrant/server1/id_rsa.pub ]; then
    cat /vagrant/server1/id_rsa.pub >> $SSH_DIR/authorized_keys
    chmod 644 $SSH_DIR/authorized_keys
    chown vagrant:wheel $SSH_DIR/authorized_keys
  fi
  ;;
  esac

 



