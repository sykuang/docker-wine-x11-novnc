#!/bin/bash

if [ ! -f /etc/ssh/ssh_host_rsa_key] ; then
# Generate ssh key
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
fi
/usr/bin/supervisord
