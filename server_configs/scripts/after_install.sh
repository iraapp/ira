#!/usr/bin/env bash

# Install libaries
cd /var/www/backend
cp .env.example .env
python3 -m venv venv
source venv/bin/activate
pip install wheel
pip install 2to3
pip install -r requirements.txt
cd api
python manage.py migrate
mkdir static
python manage.py collectstatic --no-input

# Set permission for all files
sudo chown -R www-data:www-data /var/www/

# Restart services
sudo a2enmod rewrite
sudo service apache2 restart
