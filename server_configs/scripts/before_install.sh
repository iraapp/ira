
#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y python3-dev python3-pip apache2 libapache2-mod-wsgi-py3 python3.8-venv
sudo rm -rf /etc/apache2/sites-enabled/000-default.conf
sudo rm -rf /etc/apache2/sites-available/000-default.conf
sudo rm -rf /var/www/backend
