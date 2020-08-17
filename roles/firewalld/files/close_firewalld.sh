#!/bin/bash
# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld
# 关闭 SELinux
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
