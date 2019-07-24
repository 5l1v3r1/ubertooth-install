#!/bin/bash

#
# Ubertooth install script for Raspbian
#
# Originally by Raul Siles
# Copyright (c) 2015 DinoSec SL (www.dinosec.com)
#
# Modified by Jason Baird
#
# Version: 2017-03-R2
# Date: 2015-10-31
#
# Ubertooth and libbtbb versions: 2018-12-R1
# Kismet version: 2016-07-R1
#

# Versions
VERSION=2018-12-R1
UBER_VERSION=2018-12-R1
KISMET_VERSION=Latest

LIBBTBB_URL=https://github.com/greatscottgadgets/libbtbb/archive/$UBER_VERSION.tar.gz
LIBBTBB_FILENAME=libbtbb-$UBER_VERSION.tar.gz
LIBBTBB_DIR=libbtbb-$UBER_VERSION
LIBBTBB_BACK=../..

UBERTOOTH_URL=https://github.com/greatscottgadgets/ubertooth/releases/download/$UBER_VERSION/ubertooth-$UBER_VERSION.tar.xz
UBERTOOTH_FILENAME=ubertooth-$UBER_VERSION.tar.xz
UBERTOOTH_DIR_HOST=ubertooth-$UBER_VERSION/host
UBERTOOTH_DIR=ubertooth-$UBER_VERSION
UBERTOOTH_BACK=../../..

KISMET_BACK=..

# ASCII Art:
# http://patorjk.com/software/taag/
# Based on figlet

echo
echo "  _   _ _               _              _   _       _____          _        _ _ "
echo " | | | | |             | |            | | | |     |_   _|        | |      | | |"
echo " | | | | |__   ___ _ __| |_ ___   ___ | |_| |__     | | _ __  ___| |_ __ _| | |"
echo " | | | |  _ \ / _ \ ^__| __/ _ \ / _ \| __|  _ \    | || ^_ \/ __| __/ _^ | | |"
echo " | |_| | |_) |  __/ |  | || (_) | (_) | |_| | | |  _| || | | \__ \ || (_| | | |"
echo "  \___/|_.__/ \___|_|   \__\___/ \___/ \__|_| |_|  \___/_| |_|___/\__\__,_|_|_|"
echo

echo
echo " - Script to install Ubertooth $UBER_VERSION and Kismet $KISMET_VERSION"
echo
echo "   Version: $VERSION"
echo "   By Raul Siles (DinoSec - www.dinosec.com)"
echo
echo "   Tools Versions:"
echo "   - Ubertooth & libbtbb: $UBER_VERSION"
echo "   - Kismet: $KISMET_VERSION"
echo

echo "  (*** Internet access is required ***)"
echo "  (*** This script will run for a few minutes. Be patient... ***)"
echo
echo "  Press any key to continue (or Ctrl+C):"
read key

echo "[*] Installing Ubertooth dependencies..."
echo
sudo apt-get -y install cmake libusb-1.0-0-dev make gcc g++ libbluetooth-dev \
pkg-config libpcap-dev python-numpy python-pyside python-qt4

echo
echo "[*] Building the Bluetooth baseband library (libbtbb)..."
wget $LIBBTBB_URL -O $LIBBTBB_FILENAME
tar xf $LIBBTBB_FILENAME
cd $LIBBTBB_DIR
mkdir build
cd build
cmake ..
make
sudo make install
cd $LIBBTBB_BACK

echo
echo "[*] Installing Ubertooth tools..."
echo
wget $UBERTOOTH_URL -O $UBERTOOTH_FILENAME
tar xf $UBERTOOTH_FILENAME
cd $UBERTOOTH_DIR_HOST
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig
cd $UBERTOOTH_BACK

echo
echo "[*] Building Kismet and the Ubertooth Kismet plugin..."
echo
sudo apt-get -y install libpcap0.8-dev libcap-dev pkg-config build-essential libnl-3-dev libnl-genl-3-dev libncurses5-dev libpcre3-dev libpcap-dev libcap-dev
wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key | sudo apt-key add -
echo 'deb https://www.kismetwireless.net/repos/apt/release/buster stretch main' | sudo tee /etc/apt/sources.list.d/kismet.list
sudo apt update
sudo apt install kismet

echo
echo "[*] End of the install script. Congratulations! ;)"
echo
