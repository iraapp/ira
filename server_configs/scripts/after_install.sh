#!/usr/bin/env bash

# Install libaries
cd /var/www/backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cd api
python manage.py migrate
python manage.py collectstatic --no-input

# Set permission for all files
sudo chown -R www-data:www-data /var/www/

# Restart services
sudo service apache2 restart