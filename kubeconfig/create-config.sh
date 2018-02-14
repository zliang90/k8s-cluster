#!/bin/bash

# 设置本机IP 
export K8SHA_IPLOCAL=192.168.2.101

# 设置本地etc节点名，选项： etcd1, etcd2, etcd3
export K8SHA_ETCDNAME=etcd1

# keepalived节点角色, options: MASTER, BACKUP. 
export K8SHA_KA_STATE=MASTER

# 配置keepalived节点优先级, 选项： 120, 110, 100. MASTER must 120
export K8SHA_KA_PRIO=120

# 设置keepalived网络接口名称
export K8SHA_KA_INTF=ens32

#######################################
# all masters settings below must be same
#######################################

# 虚拟IP
export K8SHA_IPVIRTUAL=192.168.2.100

# 第一master节点IP
export K8SHA_IP1=192.168.2.101

# 第二master节点IP
export K8SHA_IP2=192.168.2.102

# 第三master节点IP
export K8SHA_IP3=192.168.2.103

# 第一master节点IP
export K8SHA_HOSTNAME1=master01

# 第二master节点IP
export K8SHA_HOSTNAME2=master02

# 第三master节点IP
export K8SHA_HOSTNAME3=master03

# keepalived 认证字符串
export K8SHA_KA_AUTH=4cdf7dc3b4c90194d1600c483e10ad1d

# kubernetes集群Token，可使用 'kubeadm token generate'创建
export K8SHA_TOKEN=7f276c.0741d82a5337f526

# kubernetes CIDR POD网络
export K8SHA_CIDR=10.244.0.0\\/16

##############################
# please do not modify anything below
##############################

# set etcd cluster docker-compose.yaml file
sed \
-e "s/K8SHA_ETCDNAME/$K8SHA_ETCDNAME/g" \
-e "s/K8SHA_IPLOCAL/$K8SHA_IPLOCAL/g" \
-e "s/K8SHA_IP1/$K8SHA_IP1/g" \
-e "s/K8SHA_IP2/$K8SHA_IP2/g" \
-e "s/K8SHA_IP3/$K8SHA_IP3/g" \
etcd/docker-compose.yaml.tpl > etcd/docker-compose.yaml

echo 'set etcd cluster docker-compose.yaml file success: etcd/docker-compose.yaml'

# set keepalived config file
mv /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak

sed \
-e "s/K8SHA_KA_STATE/$K8SHA_KA_STATE/g" \
-e "s/K8SHA_KA_INTF/$K8SHA_KA_INTF/g" \
-e "s/K8SHA_IPLOCAL/$K8SHA_IPLOCAL/g" \
-e "s/K8SHA_KA_PRIO/$K8SHA_KA_PRIO/g" \
-e "s/K8SHA_IPVIRTUAL/$K8SHA_IPVIRTUAL/g" \
-e "s/K8SHA_KA_AUTH/$K8SHA_KA_AUTH/g" \
-e "s/K8SHA_IP1/$K8SHA_IP1/g" \
-e "s/K8SHA_IP2/$K8SHA_IP2/g" \
-e "s/K8SHA_IP3/$K8SHA_IP3/g" \
keepalived/keepalived.conf.tpl > /etc/keepalived/keepalived.conf

echo 'set keepalived config file success: /etc/keepalived/keepalived.conf'
echo 'Please modify the 'unicaster_peer' zone of keepalived.conf'

# set kubeadm init config file
sed \
-e "s/K8SHA_HOSTNAME1/$K8SHA_HOSTNAME1/g" \
-e "s/K8SHA_HOSTNAME2/$K8SHA_HOSTNAME2/g" \
-e "s/K8SHA_HOSTNAME3/$K8SHA_HOSTNAME3/g" \
-e "s/K8SHA_IP1/$K8SHA_IP1/g" \
-e "s/K8SHA_IP2/$K8SHA_IP2/g" \
-e "s/K8SHA_IP3/$K8SHA_IP3/g" \
-e "s/K8SHA_IPVIRTUAL/$K8SHA_IPVIRTUAL/g" \
-e "s/K8SHA_TOKEN/$K8SHA_TOKEN/g" \
-e "s/K8SHA_CIDR/$K8SHA_CIDR/g" \
kubeadm-init.yaml.tpl > kubeadm-init.yaml

echo 'set kubeadm init config file success: kubeadm-init.yaml'

