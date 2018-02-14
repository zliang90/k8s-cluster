global_defs {
   router_id LVS_KUBE_CLUSTER
}

vrrp_script CheckK8sMaster {
    script "/usr/bin/curl -k https://K8SHA_IPLOCAL:6443"
    interval 3
    timeout 9
    fall 2
    rise 2
}

vrrp_instance VI_1 {
    state K8SHA_KA_STATE
    interface K8SHA_KA_INTF
    virtual_router_id 61
    priority K8SHA_KA_PRIO
    advert_int 1
    mcast_src_ip K8SHA_IPLOCAL
    nopreempt
    authentication {
        auth_type PASS
        auth_pass K8SHA_KA_AUTH
    }
    unicast_peer {
        K8SHA_IP1
      	K8SHA_IP2
        K8SHA_IP3
    }
    virtual_ipaddress {
        K8SHA_IPVIRTUAL
    }
    track_script {
        CheckK8sMaster
    }

}
