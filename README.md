# k8s-cluster

文章旨在介绍使用**kubeadm**建立的multi master kubernetes集群。

## 基础环境

- 系统：CentOS 7-1078-minimal
- kernel：3.10.0-693.el7.x86_64
- kubernets：v1.9.2
- etcd: 3.1.11
- docker-ce: 17.03.2   kubeadm支持的最大版本

**注意：** *cluster所有基础组件采用容器化方式建立*

### 镜像列表

|镜像|说明|强制|节点|
|----|----|----|----|
|gcr.io/google_containers/etcd-amd64:3.1.11|集群状态存储|必要|master|
|gcr.io/google_containers/kube-apiserver-amd64:v1.9.2|Cluster操作核心入口|必要|master|
|gcr.io/google_containers/kube-controller-manager-amd64:v1.9.2|资源对象控制中心|必要|master|
|gcr.io/google_containers/kube-scheduler-amd64:v1.9.2|调度中心|必要|master|
|gcr.io/google_containers/kube-proxy-amd64:v1.9.2|通信与负载均衡|必要|master/node|
|gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.7|DNS|可选用其他DNS服务|master|
|gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.7|DNS|可选组件，与上一镜像共同使用|master|
|gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.7|DNS|可选组件，与上一镜像共同使用|master|
|gcr.io/google_containers/pause-amd64:3.0|POD根容器|必要|master|

## 系统预设(所有节点包括master和node)

1.关闭selinux

```bash
vim /etc/selinux/conf
设置SELINUX=DISABLED

设置当前环境生效，执行
setenforce 0
```

2.关闭firewalld（非必要，如果不关闭需要设置开放指定端口，内部使用集群建议关闭

```bash
systemctl disable firewalld && systemctl stop firewalld && systemctl status firewalld
```

3.设置桥接及路由转发的内核参

```bash
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system
```

4.关闭swap

```bash
swapoff -a

vim /etc/fstab
删除或注释掉
/dev/mapper/centos-swap swap  swap  defaults  0 0

检查swap状态
cat /proc/swaps
```

## 安装Docker-ce

**注意：** *所有相关程序均在all_in_one路径下*

cd docker-ce

```bash
yum localinstall -y docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
yum localinstall -y docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm
```

**注意：** *由于docker-ce默认的cgroups与kubelet不同，此处修改docker-ce的cgroups*

修改配置文件/usr/lib/systemd/system/docker.service

```bash
 ExecStart=/usr/bin/dockerd  --exec-opt native.cgroupdriver=systemd
```

```bash
systemctl daemon-reload
systemctl enable docker && systemctl start docker && systemctl status docker
```

## 安装Cluster所需的必要镜像

**注意** *首先核对镜像列表中的docker images；all_in_one包中提供了镜像的tar文件，进入images目录，输入以下命令*

```bash
for image in $PWD/*; do docker load -i ${image} ; done
```

由于国内墙的原因，gcr的镜像无法下载，采用此种方式导入镜像节省时间，本人将在docker hub上提供常用镜像，但下载之后需要使用docker tag为镜像制作适合的标签。

## 安装kubernetes集群所需的相关组件

- socat
- kubernetes-cni
- kubelet
- kubectl
- kubeadm

切换至all_in_one中kuberpm路径顺序执行下列命令

```bash
rpm -ivh socat-1.7.3.2-2.el7.x86_64.rpm
rpm -ivh kubernetes-cni-0.6.0-0.x86_64.rpm  kubelet-1.9.2-0.x86_64.rpm  kubectl-1.9.2-0.x86_64.rpm
rpm -ivh kubeadm-1.9.2-0.x86_64.rpm
```