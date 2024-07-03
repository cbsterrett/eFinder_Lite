# eFinder Lite
code for AltAz telescopes (primarily Dobsonians) to utilise plate-solving to improve pointing accuracy.

Requires:

- microSd card loaded with Raspberry Pi 64bit Bookworm OS Lite (No desktop)
- On first boot, increase the swapfile size from 100M to 512M. (sudo nano /etc/dphys-swapfile)
- Raspberry Pi Zero 2W.
- Waveshare 4 port USB and UART HAT for the Pi Zero.  
- A custom box (Raspberry Pi Zero, HAT, OLED display and switches)
- A Nexus DSC with optical encoders. USB cable from Nexus port to the UART port on the Pi Zero
- A Camera, either the RP HQ Camera module of an ASI Camera (Suggest ASI120MM-S)
- Camera lens, either 25 or 50mm. f1.8 or faster cctv lens

Full details at [
](https://astrokeith.com/equipment/efinder/)https://astrokeith.com/equipment/efinder/

## Operation
Plug the eFinder into the Nexus DSC port.
Turn on the Nexus DSC which will power up the eFinder Lite
The eFinder Lite will autostart on power up.


ssh & Samba file sharing is enabled at efinder.local

A forum for builders and users can be found at https://groups.io/g/eFinder

