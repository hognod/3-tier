#! /bin/bash

until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 5
done

sudo dpkg -i ~/postgresql-installer/*.deb