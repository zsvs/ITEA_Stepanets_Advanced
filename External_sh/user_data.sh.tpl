#!/bin/bash
apt update && apt upgrade -y
apt install nginx -y

cat <<EOF > /var/www/html/index.html
<html>
<h1> NGINX home work</h1>
<p> Created by ${f_name} ${f_nick}</p>
%{endfor ~}
EOF

service nginx start
