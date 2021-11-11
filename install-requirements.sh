#!/bin/bash
sudo apt-get update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ubuntugis/ppa
sudo apt-get update
sudo apt-get -y upgrade
sudo apt update
sudo apt-get install -y build-essential
sudo apt-get install -y gdal-bin
sudo apt-get install -y python-gdal
sudo apt-get install -y python3-gdal
sudo apt-get install -y libgdal-dev
sudo apt-get install -y python3-dask
sudo apt-get install -y python3-psycopg2
sudo apt-get install -y python3-geopandas

sudo apt-get install -y python3-pip

sudo mkdir /home/cc/
sudo chmod 775 -R /home/cc/
sudo chown azureuser:azureuser /home/cc/
git clone https://github.com/conservation-innovation-center/landuse.git /home/cc/landuse

sudo pip3 install -r /home/cc/landuse/install/requirements.txt
sudo pip3 install dask distributed --upgrade
sudo pip3 install jsonformatter
#  -----

wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install blobfuse


(
  echo accountName cbpbigshare
  echo authType MSI
  echo identityObjectId 63116962-c165-4b9a-9dfa-ea19fc703430
  echo containerName batching
) > ~/MSI_fuse_connection.cfg

chmod 600 ~/MSI_fuse_connection.cfg

sudo mkdir /mnt/resource/blobfusetmp -p
sudo chown azureuser /mnt/resource/blobfusetmp

mkdir /home/azureuser/azData
#fusermount -u azData
blobfuse /home/azureuser/azData --tmp-path=/mnt/resource/blobfusetmp --config-file=/home/azureuser/MSI_fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120
ls -la /home/azureuser/azData

sudo apt -y install gnupg2
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
sudo apt-get update
sudo apt-get -y install postgresql-13.1 postgresql-client-13.1
sudo apt-get -y install postgis
sudo apt-get -y install postgresql-13.1-postgis-3.1

sudo su - postgres
createdb landuse_gis
psql -c "CREATE EXTENSION IF NOT EXISTS postgis;" -d landuse_gis -U postgres
psql -c "CREATE EXTENSION IF NOT EXISTS postgis_topology;" -d landuse_gis -U postgres
psql -c "create user landuse_db_svc with encrypted password 'landuse_db_svc';"
psql -c "grant all privileges on database landuse_gis to landuse_db_svc;"
exit


