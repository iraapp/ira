
#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y python3 python-dev python3-pip apache2 libapache2-mod-wsgi-py3 python3-pip
sudo rm -rf /var/www/backend
