# k8s-cluster
文章旨在介绍使用**kubeadm**建立的multi master kubernetes集群。

## 基础环境
- 系统：CentOS 7-1078-minimal
- kernel：**版本未定**
- kubernets：v1.9.2
- etcd: **版本未定**
- docker-ce: 17.03.2   kubeadm支持的最大版本

**注意：** *cluster所有基础组件采用容器化方式建立*

## 系统预设
1. 关闭selinux
```
vim /etc/selinux/conf
设置SELINUX=DISABLED
设置当前环境生效，执行
setenforce 0
```

2. 关闭firewalld（非必要，如果不关闭需要设置开放指定端口，内部使用集群建议关闭）
