ip link set dev eth1 up
ip link set dev eth2 up
ip a add 192.168.155.3/24 dev eth1
ip a add 192.168.166.5/24 dev eth2
ip r add 16.0.0.0/8 via 192.168.155.2
ip r add 48.0.0.0/8 via 192.168.166.4
ip n add 192.168.155.2 dev eth1 lladdr fa:3f:1f:83:95:01
ip n add 192.168.166.4 dev eth2 lladdr fa:09:10:ca:11:02
echo 1 > /proc/sys/net/ipv4/ip_forward
