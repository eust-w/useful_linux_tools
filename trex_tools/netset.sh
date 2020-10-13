rm -f /etc/trex_cfg.yaml
rm -f /etc/trex_cfg.yaml.bak
rm -rf ./trex
a=(`ip a | grep ^[1-9] | awk -F: '{print $2}' | sed '1,2d'`)
for ((i=0;i<2;i++))
  do
    b[$i]=`ethtool -i ${a[$i]} |grep bus | awk -F ':' '{print $3 $4 $5}'|sed -e 's/../\0:/'`
  done
for ((i=0;i<2;i++))
  do
    echo ${a[$i]} ${b[$i]} 
  done
mkdir trex
cd trex
wget --no-cache http://192.168.200.100/mirror/longtao.wu/tools/guest+linux/trex-tar
tar -zxvf trex-tar
cp /root/trex/v2.81/cfg/simple_cfg.yaml  /etc/trex_cfg.yaml.bak
sed '4,$d' /etc/trex_cfg.yaml.bak >/etc/trex_cfg.yaml
echo -e '  interfaces    : ["'${b[0]}'","'${b[1]}'"]'>>/etc/trex_cfg.yaml
echo -e '  port_info       :  # Port IPs. Change to suit your needs. In case of loopback, you can leave as is.'>>/etc/trex_cfg.yaml
echo -e '          - ip         : 192.168.155.2'>>/etc/trex_cfg.yaml
echo -e '            default_gw : 192.168.155.3'>>/etc/trex_cfg.yaml
echo -e '          - ip         : 192.168.166.4'>>/etc/trex_cfg.yaml
echo -e '            default_gw : 192.168.166.5'>>/etc/trex_cfg.yaml
echo -e '\n\n'>>/etc/trex_cfg.yaml
cd ~/trex/v2.81/
./dpdk_setup_ports.py
# cat /etc/trex_cfg.yaml
cat /root/trex/v2.81/cfg/simple_cfg.yaml
cat /etc/trex_cfg.yaml