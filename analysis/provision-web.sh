#!/usr/bin/env bash
set -eux

SERVER_ID=$1
IP=$2

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx

cat > /var/www/html/index.html <<EOF
<html>
  <head><title>Web Server ${SERVER_ID}</title></head>
  <body>
    <h1>Servidor web ${SERVER_ID}</h1>
    <p>IP: ${IP}</p>
    <p>Timestamp: $(date -u +"%Y-%m-%d %H:%M:%S UTC")</p>
  </body>
</html>
EOF

chown -R www-data:www-data /var/www/html
systemctl enable nginx
systemctl restart nginx
