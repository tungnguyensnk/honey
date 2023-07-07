#!/bin/sh
# tạo chain HONEYGAIN
iptables -t nat -N HONEYGAIN1

# bỏ qua các địa chỉ IP nội bộ
iptables -t nat -A HONEYGAIN1 -d 0.0.0.0/8 -j RETURN
iptables -t nat -A HONEYGAIN1 -d 10.0.0.0/8 -j RETURN
iptables -t nat -A HONEYGAIN1 -d 127.0.0.0/8 -j RETURN
iptables -t nat -A HONEYGAIN1 -d 169.254.0.0/16 -j RETURN
iptables -t nat -A HONEYGAIN1 -d 172.16.0.0/12 -j RETURN
iptables -t nat -A HONEYGAIN1 -d 192.168.0.0/16 -j RETURN
iptables -t nat -A HONEYGAIN1 -d 224.0.0.0/4 -j RETURN
iptables -t nat -A HONEYGAIN1 -d 240.0.0.0/4 -j RETURN

# mọi tcp connection đến sẽ được redirect về port 12345
iptables -t nat -A HONEYGAIN1 -p tcp -j REDIRECT --to-ports 12345

# áp dụng chain HONEYGAIN1 cho user root  -d 104.26.12.49/16,172.67.71.104/16
iptables -t nat -A OUTPUT -p tcp -d 104.26.12.49/16,172.67.71.104/16 -m owner --uid-owner root -j HONEYGAIN1

# tạo file cấu hình redsocks.conf
cat << EOF > redsocks1.conf
base {
 log_debug = off;
 log_info = on;
 log = "file:/var/log/redsocks1.log";
 daemon = on;
 redirector = iptables;
}
redsocks {
 local_ip = 127.0.0.1;
 local_port = 12345;
 ip = mitmproxy;
 port = 8080;
 type = socks5;
}
EOF

# tạo chain HONEYGAIN
iptables -t nat -N HONEYGAIN2

# bỏ qua các địa chỉ IP nội bộ
iptables -t nat -A HONEYGAIN2 -d 0.0.0.0/8 -j RETURN
iptables -t nat -A HONEYGAIN2 -d 10.0.0.0/8 -j RETURN
iptables -t nat -A HONEYGAIN2 -d 127.0.0.0/8 -j RETURN
iptables -t nat -A HONEYGAIN2 -d 169.254.0.0/16 -j RETURN
iptables -t nat -A HONEYGAIN2 -d 172.16.0.0/12 -j RETURN
iptables -t nat -A HONEYGAIN2 -d 192.168.0.0/16 -j RETURN
iptables -t nat -A HONEYGAIN2 -d 224.0.0.0/4 -j RETURN
iptables -t nat -A HONEYGAIN2 -d 240.0.0.0/4 -j RETURN

# mọi tcp connection đến sẽ được redirect về port 12345
iptables -t nat -A HONEYGAIN2 -p tcp -j REDIRECT --to-ports 12346

# áp dụng chain HONEYGAIN2 cho user root  -d 104.26.12.49/16,172.67.71.104/16
iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner root -j HONEYGAIN2

# tạo file cấu hình redsocks.conf
cat << EOF > redsocks2.conf
base {
 log_debug = off;
 log_info = on;
 log = "file:/var/log/redsocks2.log";
 daemon = on;
 redirector = iptables;
}
redsocks {
 local_ip = 127.0.0.1;
 local_port = 12346;
 ip = gost;
 port = 40000;
 type = socks5;
}
EOF

# thêm cert của mitmproxy vào hệ thống
cp ~/.mitmproxy/mitmproxy-ca-cert.pem /usr/local/share/ca-certificates/mitmproxy.crt
update-ca-certificates
if [ "$DEVICE_ID" = "1" ]; then
  while sleep 3; do curl https://api.honeygain.com/api/v1/users/me --header 'x-api-request: true'; done > /dev/null 2>&1 &
fi
redsocks -c redsocks1.conf
redsocks -c redsocks2.conf
./honeygain -tou-accept -email "$EMAIL" -pass "$PASSWORD" -device "$DEVICE_ID"
