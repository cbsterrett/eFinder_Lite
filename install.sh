#!/bin/sh

echo "eFinder install"
echo " "
echo "*****************************************************************************"
echo "Updating Pi OS & packages"
echo "*****************************************************************************"
sudo apt update
sudo apt upgrade -y
echo " "
echo "*****************************************************************************"
echo "Installing additional Debian and Python packages"
echo "*****************************************************************************"
sudo apt install -m -y python3-pip
sudo apt install -y python3-serial
sudo apt install -y python3-psutil
sudo apt install -y python3-pil
sudo apt install -y python3-pil.imagetk
sudo apt install -y git
sudo apt install -y python3-smbus

HOME=/home/efinder
echo " "
echo "*****************************************************************************"
echo "Installing new astrometry packages"
echo "*****************************************************************************"
sudo apt install -y python3-skyfield
sudo apt install -y python3-pil.imagetk

python -m venv /home/efinder/venv-efinder --system-site-packages
venv-efinder/bin/python venv-efinder/bin/pip install git+https://github.com/esa/tetra3.git
venv-efinder/bin/python venv-efinder/bin/pip install adafruit-circuitpython-adxl34x

cd $HOME
echo " "
echo "*****************************************************************************"
echo "Downloading eFinder_Lite from AstroKeith GitHub"
echo "*****************************************************************************"
sudo -u efinder git clone https://github.com/AstroKeith/eFinder_Lite.git
echo " "
echo "*****************************************************************************"
echo "Installing ASI camera support"
echo "*****************************************************************************"
cd eFinder_Litetar xf ASI_linux_mac_SDK_V1.31.tar.bz2
cd ASI_linux_mac_SDK_V1.31/lib
sudo mkdir /lib/zwoasi
sudo mkdir /lib/zwoasi/armv8
sudo cp armv8/*.* /lib/zwoasi/armv8
sudo install asi.rules /lib/udev/rules.d
cd $HOME
venv-efinder/bin/python venv-efinder/bin/pip install zwoasi

echo "tmpfs /var/tmp tmpfs nodev,nosuid,size=10M 0 0" | sudo tee -a /etc/fstab > /dev/null
echo " "
echo "*****************************************************************************"
echo "Installing required packages"
echo "*****************************************************************************"
mkdir /home/efinder/Solver
mkdir /home/efinder/Solver/images
mkdir /home/efinder/Solver/data

cp /home/efinder/eFinder_Lite/Solver/*.* /home/efinder/Solver
cp /home/efinder/eFinder_Lite/Solver/de421.bsp /home/efinder
cp /home/efinder/eFinder_Lite/Solver/starnames.csv /home/efinder/Solver/data
cp /home/efinder/eFinder_Lite/Solver/generate_database.py /home/efinder/venv-efinder/lib/python3.11/site-packages/tetra3
echo " "
echo "*****************************************************************************"
echo "Installing OLED & GPIO drivers"
echo "*****************************************************************************"
wget https://github.com/joan2937/lg/archive/master.zip
unzip master.zip
cd lg-master
sudo make install
sudo apt install -y python3-rpi-lgpio
cd /home/efinder/Solver
unzip drive.zip

cd $HOME
echo " "
echo "*****************************************************************************"
echo "Installing Samba file share support"

sudo apt install -y samba samba-common-bin
sudo tee -a /etc/samba/smb.conf > /dev/null <<EOT
[efindershare]
path = /home/efinder
writeable=Yes
create mask=0777
directory mask=0777
public=no
EOT
username="efinder"
pass="efinder"
(echo $pass; sleep 1; echo $pass) | sudo smbpasswd -a -s $username
sudo systemctl restart smbd

cd $HOME
echo " "
echo "*****************************************************************************"
echo "Downloading Tetra databases"
echo "*****************************************************************************"
venv-efinder/bin/python venv-efinder/bin/pip install gdown
venv-efinder/bin/gdown  --output /home/efinder/Solver/data --folder https://drive.google.com/drive/folders/1uxbdttpg0Dpp8OuYUDY9arYoeglfZzcX
echo " "
echo "*****************************************************************************"
echo "Final eFinder_Lite configuration setting"
echo "*****************************************************************************"
sudo chmod a+rwx eFinder_Lite/Solver/my_cron
sudo cp Solver/my_cron /etc/cron.d

sudo raspi-config nonint do_boot_behaviour B2
sudo raspi-config nonint do_hostname efinder
sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_serial_hw 0
sudo raspi-config nonint do_serial_cons 1
sudo raspi-config nonint do_spi 0
sudo raspi-config nonint do_i2c 0

sudo reboot now

