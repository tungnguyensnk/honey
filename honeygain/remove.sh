iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
killall redsocks
