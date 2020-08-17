### 配置hosts
```
vim /etc/hosts
```
### 配置ansible hosts
```
# cat /etc/ansible/hosts
[mysqlservers]
192.168.1.10
192.168.1.11
192.168.1.12
```
### 设置免密码登录
```
# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:LWlZF1wN83h7hEkWb7z/q7uyDKeqyiXnktEdueh0/pE root@ansible
The key's randomart image is:
+---[RSA 2048]----+
|           ...B+ |
|            .+ O.|
|        . . . + B|
|       o = .   +o|
|    . o S .    o.|
|   . + = ..     o|
|   .=oo  E .    .|
|  .o=. .  *.    .|
|   ooo..oo oo++.o|
+----[SHA256]-----+

# ssh-copy-id 192.168.1.10
# ssh-copy-id 192.168.1.11
# ssh-copy-id 192.168.1.12
```
### 测试
```
# ansible '*' -m ping
192.168.1.10 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
192.168.1.11 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
192.168.1.12 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```
### 执行
```
# ansible-playbook mysql.yaml

PLAY [mysqlservers] **************************************************************************************************************************************************

TASK [mysql : copy install_script to client] *************************************************************************************************************************
changed: [192.168.1.10]
changed: [192.168.1.11]
changed: [192.168.1.12]

TASK [install mysql] *************************************************************************************************************************************************
changed: [192.168.1.12]
......
```
### 验证mysql
```
# systemctl status mysqld
● mysqld.service - MySQL Server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2020-08-17 19:11:07 CST; 15min ago
     Docs: man:mysqld(8)
           http://dev.mysql.com/doc/refman/en/using-systemd.html
  Process: 12590 ExecStart=/usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid $MYSQLD_OPTS (code=exited, status=0/SUCCESS)
  Process: 12540 ExecStartPre=/usr/bin/mysqld_pre_systemd (code=exited, status=0/SUCCESS)
 Main PID: 12593 (mysqld)
   CGroup: /system.slice/mysqld.service
           └─12593 /usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid

Aug 17 19:11:03 demo2 systemd[1]: Starting MySQL Server...
Aug 17 19:11:07 demo2 systemd[1]: Started MySQL Server.
# mysql -uroot -p123456
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 5.7.31 MySQL Community Server (GPL)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.00 sec)

mysql>

# systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)

Aug 17 20:04:39 demo2 systemd[1]: Starting firewalld - dynamic firewall daemon...
Aug 17 20:04:39 demo2 systemd[1]: Started firewalld - dynamic firewall daemon.
Aug 17 20:04:53 demo2 systemd[1]: Stopping firewalld - dynamic firewall daemon...
Aug 17 20:04:54 demo2 systemd[1]: Stopped firewalld - dynamic firewall daemon.
```
