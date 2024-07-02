#!/bin/sh

echo "eFinder install"
echo " "
echo "*****************************************************************************"
#sudo rpi-update -y

sudo apt update
sudo apt upgrade -y

HOME=/home/efinder

#sudo apt-get install -y libcairo2-dev libnetpbm11-dev netpbm libpng-dev libjpeg-dev zlib1g-dev libbz2-dev swig libcfitsio-dev
# sudo -u efinder python3 -m pip install --upgrade pip

#sudo apt install -y python3-fitsio
#sudo apt install -y imagemagick
sudo apt install -y python3-skyfield
sudo apt install -y python3-pil.imagetk

python -m venv /home/efinder/venv-efinder --system-site-packages
#venv-efinder/bin/python venv-efinder/bin/pip install astropy pyfits
venv-efinder/bin/python venv-efinder/bin/pip install git+https://github.com/esa/tetra3.git
venv-efinder/bin/python venv-efinder/bin/pip install adafruit-circuitpython-adxl34x

cd $HOME

echo ""

#sudo sh -c "echo export PATH=$PATH:/usr/local/astrometry/bin >> /etc/profile"

cd /efinder/venv-efinder/lib/python3.11/site-packages/tetra3
sudo wget https://cdsarc.u-strasbg.fr/ftp/cats/I/239/hip_main.dat


cd $HOME

sudo -u efinder git clone https://github.com/AstroKeith/eFinder_Lite.git

cd eFinder_Lite

tar xf ASI_linux_mac_SDK_V1.31.tar.bz2
cd ASI_linux_mac_SDK_V1.31/lib

sudo mkdir /lib/zwoasi
sudo mkdir /lib/zwoasi/armv8
sudo cp armv8/*.* /lib/zwoasi/armv8
sudo install asi.rules /lib/udev/rules.d

cd $HOME

venv-efinder/bin/python venv-efinder/bin/pip install zwoasi

cd $HOME

echo "tmpfs /var/tmp tmpfs nodev,nosuid,size=10M 0 0" | sudo tee -a /etc/fstab > /dev/null

mkdir /home/efinder/Solver
mkdir /home/efinder/Solver/images
mkdir /home/efinder/Solver/data

echo ""
cp /home/efinder/eFinder_Lite/Solver/*.* /home/efinder/Solver
cp /home/efinder/eFinder_Lite/Solver/de421.bsp /home/efinder
cp /home/efinder/eFinder_Lite/Solver/starnames.csv /home/efinder/Solver/data
cp /home/efinder/eFinder_Lite/Solver/generate_database.py /home/venv-efinder/lib/python3.11/site-packages/tetra3

wget https://github.com/joan2937/lg/archive/master.zip
unzip master.zip
cd lg-master
sudo make install
sudo apt install -y python3-rpi-lgpio

# add crontab -e edit
# add samba?

sudo raspi-config nonint do_boot_behaviour B2
sudo raspi-config nonint do_hostname efinder
sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_serial_hw 0
sudo raspi-config nonint do_spi 0
sudo raspi-config nonint do_i2c 0

sudo reboot now

