#!/bin/bash

mkdir -p /opt/${name}

echo ${fqdn} > /opt/${name}/fqdn.txt

sudo apt update

sudo apt install -y python3-pip python-is-python3 nginx dnsutils

# sudo pip3 install flask gunicorn

sudo systemctl enable nginx
# sudo systemctl start nginx

export FQDN=${fqdn}
export IP=$(curl ifconfig.me)

while true
do
    DNS_RESULT=$(dig +short $FQDN | head -n 1)

    # Check if the DNS result matches the IP
    if [ "$DNS_RESULT" == "$IP" ]; then
        echo "The IP addresses match." > /opt/${name}/result.txt
        break
    else
        echo "The IP addresses do not match." >> /opt/${name}/log.txt
        sleep 60
    fi
done

# try to get TLS cert via certbot
sudo apt -y install certbot
sudo systemctl stop nginx
sudo certbot certonly --standalone -d ${fqdn} --non-interactive --agree-tos --email ${email}

### nginx config


cat << EOF > /etc/nginx/sites-available/${fqdn}

server {
    listen 80;
    server_name ${fqdn};

    location / {
        return 301 https://\$host\$request_uri;
    }
}


server {
        listen 443 ssl;
        server_name ${fqdn};

        ssl_certificate         /etc/letsencrypt/live/${fqdn}/fullchain.pem;
        ssl_certificate_key     /etc/letsencrypt/live/${fqdn}/privkey.pem;

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
}

EOF

# start nginx
sudo ln -s /etc/nginx/sites-available/${fqdn} /etc/nginx/sites-enabled/${fqdn}
sudo systemctl start nginx

# some logs
cd /etc/letsencrypt/live/${fqdn}/
ls -l > /opt/${name}/cert.txt
ls /var/log/cloud-init* > /opt/${name}/cloud-init.txt
