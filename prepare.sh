#!/bin/bash
set -e
source /tmp/buildconfig
set -x

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
	echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

## Enable Ubuntu Universe and Multiverse.
sudo sed -i 's/^#\s*\(deb.*restricted\)$/\1/g' /etc/apt/sources.list
sudo apt-get update

## Install things we need
sudo apt-get install -y --no-install-recommends wget unzip libfontconfig1 libfreetype6 libicu55 liblzo2-2 libsdl1.2debian

##need to install libicu52 manually as it’s a hard dependency for openttd
wget -q http://launchpadlibrarian.net/201330288/libicu52_52.1-8_amd64.deb
sudo dpkg -i libicu52_52.1-8_amd64.deb

## Download and install openttd
wget -q http://binaries.openttd.org/releases/1.6.1-RC1/openttd-1.6.1-RC1-linux-ubuntu-trusty-amd64.deb
sudo dpkg -i openttd-1.6.1-RC1-linux-ubuntu-trusty-amd64.deb
sudo mkdir -p /etc/service/openttd/

## Download GFX and install
sudo mkdir -p /usr/share/games/openttd/baseset/
cd /usr/share/games/openttd/baseset/
sudo wget -q http://bundles.openttdcoop.org/opengfx/releases/LATEST/opengfx-0.5.4.zip
sudo unzip opengfx-0.5.4.zip
sudo tar -xf opengfx-0.5.4.tar
sudo rm -rf opengfx-*.tar opengfx-*.zip


## Create openttd folders and download required files off the CDN
cd ~
mkdir .openttd

wget -q https://webttd-resources.azureedge.net/content_download.tar
mkdir .openttd/content_download
tar -xf content_download.tar -C .openttd/content_download

wget -q https://webttd-resources.azureedge.net/scripts.tar
mkdir .openttd/scripts
tar -xf scripts.tar -C .openttd/scripts

wget -q https://webttd-resources.azureedge.net/UK_2.sav
