#! /bin/bash

until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 5
done

sudo apt update

sudo dpkg -i ~/python-installer/prerequisites/*.deb
tar -zxf ~/python-installer/openssl/openssl-1.1.1w.tar.gz -C ~/
sudo mkdir -p /usr/local/ssl
cd ~/openssl-1.1.1w
./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared
sudo mv /usr/bin/openssl /usr/bin/openssl_bak
sudo make
sudo make install
sudo ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
echo export LD_LIBRARY_PATH="/usr/local/ssl/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" >> ~/.bashrc
tar -zxf ~/python-installer/python/Python-3.12.4.tgz -C ~/
cd ~/Python-3.12.4
./configure --enable-optimizations
sudo make altinstall
echo alias python="python3.12" >> ~/.bashrc