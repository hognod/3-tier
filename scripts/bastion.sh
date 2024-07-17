#! /bin/bash

until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 5
done

sudo apt update

mkdir -p ~/nginx-installer
mkdir -p ~/python-installer/prerequisites
mkdir -p ~/python-installer/openssl
mkdir -p ~/python-installer/python
mkdir -p ~/postgresql-installer

#nginx
sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx

sudo apt update
sudo apt install -y --download-only nginx
sudo mv /var/cache/apt/archives/*.deb ~/nginx-installer

#python
sudo apt install -y --download-only build-essential zlib1g zlib1g-dev libsqlite3-dev libpq-dev
sudo mv /var/cache/apt/archives/*.deb ~/python-installer/prerequisites

wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1w.tar.gz -P ~/python-installer/openssl

wget --no-check-certificate https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tgz -P ~/python-installer/python

#psql
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

sudo apt update
sudo apt install -y --download-only postgresql-16
sudo mv /var/cache/apt/archives/*.deb ~/postgresql-installer