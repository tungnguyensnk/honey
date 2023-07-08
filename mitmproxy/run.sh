#!/bin/sh
# tạo chain MITMPROXY
iptables -t nat -N MITMPROXY

# bỏ qua các địa chỉ IP nội bộ
iptables -t nat -A MITMPROXY -d 0.0.0.0/8 -j RETURN
iptables -t nat -A MITMPROXY -d 10.0.0.0/8 -j RETURN
iptables -t nat -A MITMPROXY -d 127.0.0.0/8 -j RETURN
iptables -t nat -A MITMPROXY -d 169.254.0.0/16 -j RETURN
iptables -t nat -A MITMPROXY -d 172.16.0.0/12 -j RETURN
iptables -t nat -A MITMPROXY -d 192.168.0.0/16 -j RETURN
iptables -t nat -A MITMPROXY -d 224.0.0.0/4 -j RETURN
iptables -t nat -A MITMPROXY -d 240.0.0.0/4 -j RETURN

# mọi tcp connection đến sẽ được redirect về port 12345
iptables -t nat -A MITMPROXY -p tcp -j REDIRECT --to-ports 54321

# áp dụng chain MITMPROXY cho user root  -d 104.26.12.49/16,172.67.71.104/16
iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner root -j MITMPROXY
iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner mitmproxy -j MITMPROXY

# tạo file cấu hình redsocks.conf
cat << EOF > redsocks.conf
base {
 log_debug = off;
 log_info = on;
 log = "file:/var/log/redsocks.log";
 daemon = on;
 redirector = iptables;
}
redsocks {
 local_ip = 127.0.0.1;
 local_port = 54321;
 ip = sshpass;
 port = 40000;
 type = socks5;
}
EOF
redsocks -c redsocks.conf
mitmdump -s /app/mitm.py -p 8080 --set ssl_insecure=true --allow-hosts '104.26.*.*' --allow-hosts '172.67.*.*'
