
#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y python3 python3-pip python-dev python3-pip ffmpeg supervisor apache2 libapache2-mod-wsgi-py3
pip install --user --upgrade virtualenv
sudo rm -rf /var/www/backend
