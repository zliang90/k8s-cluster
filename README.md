# k8s-cluster
文章旨在介绍使用**kubeadm**建立的multi master kubernetes集群。

## 基础环境
- 系统：CentOS 7-1078-minimal
- kernel：**版本未定**
- kubernets：v1.9.2
- etcd: **版本未定**
- docker-ce: 17.03.2   kubeadm支持的最大版本

**注意：** *cluster所有基础组件采用容器化方式建立*

## 系统预设(所有节点包括master和node)
1. 关闭selinux
```
vim /etc/selinux/conf
设置SELINUX=DISABLED

设置当前环境生效，执行
setenforce 0
```

2. 关闭firewalld（非必要，如果不关闭需要设置开放指定端口，内部使用集群建议关闭）
```
systemctl disable firewalld && systemctl stop firewalld && systemctl status firewalld
```

3. 设置桥接及路由转发的内核参数
```
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system
```

4. 关闭swap
```
swapoff -a

vim /etc/fstab
删除或注释掉
/dev/mapper/centos-swap swap  swap  defaults  0 0

检查swap状态
cat /proc/swaps
```

