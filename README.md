# eFinder Lite


![IMG_6329](https://github.com/user-attachments/assets/0eabcc3c-f5e7-4bad-b855-3142e98c168f)

## Basics

Code for AltAz telescopes (primarily Dobsonians) to utilise plate-solving to improve pointing accuracy.

Requires:

- microSd card loaded with Raspberry Pi 64bit Bookworm OS Lite (No desktop)
- Raspberry Pi Zero 2W.
- Waveshare 4 port USB and UART HAT for the Pi Zero.  
- A custom box (Raspberry Pi Zero, HAT, OLED display and switches)
- A Nexus DSC with optical encoders. USB cable from Nexus port to the UART port on the UART HAT.
- A Camera, either the RP HQ Camera module (recommended) of an ASI Camera (Suggest ASI120MM-mini)
- Camera lens, either 25 or 50mm. f1.8 or faster cctv lens

Full details at [
](https://astrokeith.com/equipment/efinder/efinder-lite)https://astrokeith.com/equipment/efinder/efinder-lite

## Compatibility

The eFinder Lite is designed to operate alongside a Nexus DSC (original & Pro). It uses the standard LX200 protcol to communicate with the Nexus DSC via its usb port.

If the Nexus DSC is connected to a drive, GoTo++ can be enabled. Directly compatible drives are ScopeDog, SiTech & SkyTracker. ServoCat drives can be used but since the Nexus DSC usb port is used to connect to the ServoCat drive, the eFinder must be configured to connect to the Nexus DSC via wifi.

A Raspberry Pi HQ camera module is strongly recommended. The Arduino clone will also work, but the config.txt file needs amending. change to camera_auto_detect=0 and add dtoverlay=IMX477

If no Nexus is found on boot, the efinder will restart as 'eFinder Live'. This uses just plate-solving to determine telescope position and relay the solution to SkySfari or similar Apps over wifi. A gps dongle or module is required.

## Operation
Plug the eFinder into the Nexus DSC port.
Turn on the Nexus DSC which will power up the eFinder Lite.
The eFinder Lite will autostart on power up.

ssh & Samba file sharing is enabled at efinder.local, or whatever hostname you have chosen.

The eFinder.config file is accessible via a browser at "efinder.local", or whatever hostname you have chosen.

A forum for builders and users can be found at https://groups.io/g/eFinder

## Acknowledgements and Licences

The eFinder Lite uses Tetra3, Cedar-Detect & Cedar-Solve. Please refer to the licence and other notes in the Tetra3 folder

