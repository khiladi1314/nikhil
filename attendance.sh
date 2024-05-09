#!/bin/bash

# Set the DEBIAN_FRONTEND environment variable to noninteractive
export DEBIAN_FRONTEND=noninteractive
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
# Update package lists
sudo apt update -y

# Install openjdk-17-jre
sudo apt install openjdk-17-jre -y

# Install software-properties-common
sudo apt install software-properties-common -y

# Add the deadsnakes PPA
sudo add-apt-repository -y ppa:deadsnakes/ppa

# Update package lists again
sudo apt update -y

# Install Python 3.11
sudo apt install python3.11 -y

# Update alternatives to use Python 3.11
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

# Install Python 3.11 development tools and libraries
#required ok
sudo apt install python3.11-dev python3.11-venv python3.11-distutils python3.11-gdbm python3.11-tk python3.11-lib2to3 -y

# Install Python 3 pip
#required ok
sudo apt install python3-pip -y 

# Install Poetry
sudo pip3 install poetry

# Download Liquibase
wget https://github.com/liquibase/liquibase/releases/download/v4.23.0/liquibase-4.23.0.tar.gz

# Create a directory for Liquibase
mkdir liquibase

# Extract Liquibase
tar -xvzf liquibase-4.23.0.tar.gz

# Install Liquibase using snap
sudo snap install liquibase



# Install flasgger and pylint
pip install flasgger

sudo pip install pylint

# Install Poetry, gunicorn, psycopg2-binary, and python-json-logger separately
pip3 install poetry gunicorn
pip install psycopg2-binary
pip install python-json-logger
pip install Flask
pip install Flask-Caching

# Install libpq-dev
#required ok
sudo apt install libpq-dev -y

# Install additional Python packages
#req ok
sudo apt install imagemagick-6.q16 -y

# Install gunicorn
#req ok
sudo apt-get install gunicorn -y

# Install Python libraries
pip install peewee
pip install voluptuous
pip install prometheus-flask-exporter
pip install redis


# Clone the repository
git clone https://github.com/OT-MICROSERVICES/attendance-api.git

# Write the content to config.yml using echo
echo '---
postgres:
  database: attendance_db
  host: 10.0.6.219
  port: 5432
  user: application
  password: password

redis:
  host: 10.0.5.137
  port: 6379
  password: ' > ~/attendance-api/config.yaml

# Write the content to liquibase.properties using echo
echo 'url=jdbc:postgresql://10.0.6.219:5432/attendance_db
driver=org.postgresql.Driver
username=application
password=password
changeLogFile=migration/db.changelog-master.xml' > ~/attendance-api/liquibase.properties

# Change directory to ~/attendance-api
cd ~/attendance-api

# Run poetry install to install dependencies
poetry install

# Run poetry update to update dependencies
poetry update

# Define the path to the service file
SERVICE_FILE_PATH="attendance-api-service-file"

# Check if the service file exists
if [ -f "$SERVICE_FILE_PATH" ]; then
    # Copy the service file to the correct location
    sudo cp "$SERVICE_FILE_PATH" /etc/systemd/system/
    
    # Reload systemd to recognize the new service file
    sudo systemctl daemon-reload
    
    echo "Attendance API service file copied and systemd reloaded."
else
    echo "Error: Attendance API service file not found at '$SERVICE_FILE_PATH'."
fi


# Exit with a success code
exit 0
