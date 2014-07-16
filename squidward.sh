# Install squid and enable all IPs on server 

# Update server
yum update -y

# Install squid
yum install squid -y

# Ensure startup flag enabled for squid
chkconfig squid on

# Start squid
service squid start

# Allow in iptables
iptables -A INPUT -p tcp -m tcp --dport 5475 -j ACCEPT

# Set my host
my_host=faces.strangled.net

# Allow my host in squid
sed -i '17i acl localnet src "$my_host"' /etc/squid/squid.conf

# Set new port for squid besides default
sed -i 's/http_port 3128/http_port 5475/' /etc/squid/squid.conf

# Add anonymous settings to config
echo "via off" >> /etc/squid/squid.conf
echo "forwarded_for off" >> /etc/squid/squid.conf
echo " " >> /etc/squid/squid.conf
echo "request_header_access Allow allow all" >> /etc/squid/squid.conf
echo "request_header_access Authorization allow all" >> /etc/squid/squid.conf
echo "request_header_access WWW-Authenticate allow all" >> /etc/squid/squid.conf
echo "request_header_access Proxy-Authorization allow all" >> /etc/squid/squid.conf
echo "request_header_access Proxy-Authenticate allow all" >> /etc/squid/squid.conf
echo "request_header_access Cache-Control allow all" >> /etc/squid/squid.conf
echo "request_header_access Content-Encoding allow" >> /etc/squid/squid.conf
echo "request_header_access Content-Length allow" >> /etc/squid/squid.conf
echo "request_header_access Content-Type allow all" >> /etc/squid/squid.conf
echo "request_header_access Date allow all" >> /etc/squid/squid.conf
echo "request_header_access Expires allow all" >> /etc/squid/squid.conf
echo "request_header_access Host allow all" >> /etc/squid/squid.conf
echo "request_header_access If-Modified-Since allow all" >> /etc/squid/squid.conf
echo "request_header_access Last-Modified allow all" >> /etc/squid/squid.conf
echo "request_header_access Location allow all" >> /etc/squid/squid.conf
echo "request_header_access Pragma allow all" >> /etc/squid/squid.conf
echo "request_header_access Accept allow all" >> /etc/squid/squid.conf
echo "request_header_access Accept-Charset allow all" >> /etc/squid/squid.conf
echo "request_header_access Accept-Encoding allow all" >> /etc/squid/squid.conf
echo "request_header_access Accept-Language allow all" >> /etc/squid/squid.conf
echo "request_header_access Content-Language allow all" >> /etc/squid/squid.conf
echo "request_header_access Mime-Version allow all" >> /etc/squid/squid.conf
echo "request_header_access Retry-After allow all" >> /etc/squid/squid.conf
echo "request_header_access Title allow all" >> /etc/squid/squid.conf
echo "request_header_access Connection allow all" >> /etc/squid/squid.conf
echo "request_header_access Proxy-Connection allow all" >> /etc/squid/squid.conf
echo "request_header_access User-Agent allow all" >> /etc/squid/squid.conf
echo "request_header_access Cookie allow all" >> /etc/squid/squid.conf
echo "request_header_access All deny all" >> /etc/squid/squid.conf

# Set IP number marker
ip_count=1

# Set sed count
sed_count=18

# Get all IPs on server & add to squid.conf
for i in `ifconfig | awk -F "[: ]+" '/inet addr:/ { if ($4 != "127.0.0.1") print $4 }'` ; do
    sed -i '"$sed_count"i acl ip"ip_count" myip "$i"' /etc/squid/squid.conf
    ((sed_count++))
     sed -i '"$sed_count"i tcp_outgoing_address "$i" ip"$ip_count"' /etc/squid/squid.conf
     ((sed_count++))
     ((ip_count++))
done

# Restart squid
service squid restart
