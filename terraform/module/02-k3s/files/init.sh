#!/usr/bin/bash

route_metadata(){
  # to access directly to scaleway metadata and avoid getting metadata from router server
  ip=$(ip -f inet addr show ens2 | awk '/inet / {print $2}' | cut -d "/" -f 1)
  cat >> /etc/netplan/50-cloud-init.yaml << EOL
            - to: 169.254.42.42/32
              via: ${ip}
EOL
  netplan apply
}

get_metadata(){
  scw-metadata-json > /root/metadata.json
}

check_net(){
    if [ -z "${interface}" ]
    then
        return
    fi
    ip a show ${interface} 2> /dev/null | grep inet > /dev/null 2>&1
    if [[ $? == 0 ]]
    then
        echo "interface ${interface} ready"
        net_ready="yes"
    fi
}

check_wg(){
    ip a show wg-pewty 2> /dev/null | grep inet > /dev/null 2>&1
    if [ $? == 0 ]
    then
        echo "interface wg-pewty ready"
        wg_ready="yes"
    fi
}

net_ready="no"
wg_ready="no"

interface=$(ls -1 /sys/class/net/*/address | grep "ens" | grep -v "ens2" | cut -d "/" -f 5)
while [ -z "${interface}" ]
do
    interface=$(ls -1 /sys/class/net/*/address | grep "ens" | grep -v "ens2" | cut -d "/" -f 5)
    sleep 5
    echo "looking for private net interface"
done

iptables -S | grep "PEWTY SETUP" > /dev/null 2>&1
if [ $? != 0 ]
then
    sysctl -w net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -o ens2 -j MASQUERADE
    iptables -A FORWARD -i ens2 -o ${interface} -m state --state RELATED,ESTABLISHED -j ACCEPT -m comment --comment "PEWTY SETUP"
    iptables -A FORWARD -i ${interface} -o ens2 -j ACCEPT
fi

route_metadata
wg-quick up wg-pewty
check_net
check_wg

while :
do
    ###########
    ## network
    ###########
    if [ "$(mc tag list scw/pewty-instance-config/$HOSTNAME/net.sh --json | jq -r '.tagset.update')" == "yes" ]
    then
        echo "updating private net interface"
        mc cat scw/pewty-instance-config/$HOSTNAME/net.sh | bash

        check_net

        if [ "$net_ready" == "yes" ]
        then
            mc tag set scw/pewty-instance-config/$HOSTNAME/net.sh "update=no"
        fi
    fi
    
    
    ###########
    ## wireguard
    ###########
    if [[ "$(mc tag list scw/pewty-instance-config/$HOSTNAME/wg.sh --json | jq -r '.tagset.update')" == "yes" && "$net_ready" == "yes" ]]
    then
        echo "updating wg interface"
        mc cat scw/pewty-instance-config/$HOSTNAME/wg.sh | bash

        check_wg

        if [ "$wg_ready" == "yes" ]
        then
            mc tag set scw/pewty-instance-config/$HOSTNAME/wg.sh "update=no"
        fi
    fi


    ###########
    ## k3s
    ###########
    if [[ "$net_ready" == "yes" && "$(mc tag list scw/pewty-instance-config/$HOSTNAME/k3s.sh --json | jq -r '.tagset.update')" == "yes" ]]
    then
        echo "updating k3s"
        mc tag set scw/pewty-instance-config/$HOSTNAME/k3s.sh "update=no"
        mc cat scw/pewty-instance-config/$HOSTNAME/k3s.sh | bash
    fi

    ###########
    ## haproxy
    ###########
    if [[ ! -z "$(kubectl get svc -n kube-system -o json traefik | jq -r '.spec.ports[] | select(.port == 80).nodePort')" && "$(mc tag list scw/pewty-instance-config/$HOSTNAME/haproxy.sh --json | jq -r '.tagset.update')" == "yes" ]]
    then
        echo "updating haproxy"
        mc tag set scw/pewty-instance-config/$HOSTNAME/haproxy.sh "update=no"
        mc cat scw/pewty-instance-config/$HOSTNAME/haproxy.sh | bash
    fi
        

    ###########
    ## kubernetes
    ###########
    if [[ ! -z "$(kubectl get svc -n kube-system -o json traefik | jq -r '.spec.ports[] | select(.port == 80).nodePort')" && "$(mc tag list scw/pewty-instance-config/$HOSTNAME/kubernetes.sh --json | jq -r '.tagset.update')" == "yes" ]]
    then
        echo "updating kubernetes"
        mc tag set scw/pewty-instance-config/$HOSTNAME/kubernetes.sh "update=no"
        mc cat scw/pewty-instance-config/$HOSTNAME/kubernetes.sh | bash
    fi
    sleep 10
done
