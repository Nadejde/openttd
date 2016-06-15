#!/bin/bash
set -e
source /tmp/buildconfig
set -x

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
	echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

## Enable Ubuntu Universe and Multiverse.
sed -i 's/^#\s*\(deb.*restricted\)$/\1/g' /etc/apt/sources.list
apt-get update

## Install things we need
$minimal_apt_get_install wget unzip libfontconfig1 libfreetype6 libicu52 liblzo2-2 libsdl1.2debian

## Create user
mkdir -p /home/openttd/.openttd
useradd -M -d /home/openttd -u 911 -U -s /bin/false openttd
usermod -G users openttd
chown openttd:openttd /home/openttd -R

## Download and install openttd
wget -q http://binaries.openttd.org/releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-linux-ubuntu-trusty-amd64.deb
sudo dpkg -i openttd-${OPENTTD_VERSION}-linux-ubuntu-trusty-amd64.deb
sudo mkdir -p /etc/service/openttd/

## Download GFX and install
sudo mkdir -p /usr/share/games/openttd/baseset/
cd /usr/share/games/openttd/baseset/
sudo wget -q http://bundles.openttdcoop.org/opengfx/releases/LATEST/opengfx-${OPENGFX_VERSION}.zip
sudo unzip opengfx-${OPENGFX_VERSION}.zip
sudo tar -xf opengfx-${OPENGFX_VERSION}.tar
sudo rm -rf opengfx-*.tar opengfx-*.zip


## Create openttd folders and download required files off the CDN
cd /home/openttd
mkdir .openttd

wget -q https://webttd-resources.azureedge.net/content_download.tar
mkdir .openttd/content_download
tar -xf content_download.tar -C .openttd/content_download

wget -q https://webttd-resources.azureedge.net/scripts.tar
mkdir .openttd/scripts
tar -xf scripts.tar -C .openttd/scripts

wget -q https://webttd-resources.azureedge.net/UK_2.sav
