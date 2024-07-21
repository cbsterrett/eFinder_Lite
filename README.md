# eFinder Lite

## Important
This variant is currently under development - may contain bugs!

The autostart version eFinder_Lite.py will start version eFinder_Lite_1_5 which uses Tetra3 for detection and solving.

If you want to use the faster Cedar-Detect version, rename eFinder_Lite_Cedar.py to eFinder_Lite.py



## Basics

Code for AltAz telescopes (primarily Dobsonians) to utilise plate-solving to improve pointing accuracy.

Requires:

- microSd card loaded with Raspberry Pi 64bit Bookworm OS Lite (No desktop)
- Raspberry Pi Zero 2W.
- Waveshare 4 port USB and UART HAT for the Pi Zero.  
- A custom box (Raspberry Pi Zero, HAT, OLED display and switches)
- A Nexus DSC with optical encoders. USB cable from Nexus port to the UART port on the Pi Zero
- A Camera, either the RP HQ Camera module of an ASI Camera (Suggest ASI120MM-mini)
- Camera lens, either 25 or 50mm. f1.8 or faster cctv lens

Full details at [
](https://astrokeith.com/equipment/efinder/)https://astrokeith.com/equipment/efinder/

## Operation
Plug the eFinder into the Nexus DSC port.
Turn on the Nexus DSC which will power up the eFinder Lite.
The eFinder Lite will autostart on power up.

ssh & Samba file sharing is enabled at efinder.local, or whatever hostname you have chosen.

The eFinder.config file is accessible via a browser at "efinder.local", or whatever hostname you have chosen.

A forum for builders and users can be found at https://groups.io/g/eFinder

