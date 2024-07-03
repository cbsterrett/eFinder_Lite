#!/bin/sh

echo "eFinder install"
echo " "
echo "*****************************************************************************"
echo "Updating Pi OS & packages"



echo "*****************************************************************************"
echo "Installing additional Debian and Python packages"

sudo apt install -y git

HOME=/home/efinder
echo "*****************************************************************************"
echo "Installing new astrometry packages"


venv-efinder/bin/python venv-efinder/bin/pip install git+https://github.com/esa/tetra3.git


cd $HOME

echo ""

cd /home/efinder/venv-efinder/lib/python3.11/site-packages/tetra3


cd $HOME
echo "*****************************************************************************"
echo "Downloading eFinder_Lite from AstroKeith GitHub"

sudo -u efinder git clone https://github.com/AstroKeith/eFinder_Lite.git

cd eFinder_Lite



echo ""
cp /home/efinder/eFinder_Lite/Solver/*.* /home/efinder/Solver
cp /home/efinder/eFinder_Lite/Solver/de421.bsp /home/efinder
cp /home/efinder/eFinder_Lite/Solver/starnames.csv /home/efinder/Solver/data


cd /home/efinder/Solver
unzip drive.zip

echo "*****************************************************************************"
echo "Downloading Tetra databases"

venv-efinder/bin/gdown  --output /home/efinder/Solver/data --folder https://drive.google.com/drive/folders/1uxbdttpg0Dpp8OuYUDY9arYoeglfZzcX

echo "*****************************************************************************"
echo "Final eFinder_Lite configuration setting"

cd $HOME
sudo cp Solver/my_cron /etc/cron.d
sudo chmod a+x /etc/cron.d/my_cron


sudo reboot now

