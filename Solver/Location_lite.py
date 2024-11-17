
import time
from skyfield.api import Star, wgs84
#from datetime import datetime, timedelta
import os
import Display_Lite
import Coordinates_Lite
import serial

# Uses a USB GPS dongle

class Geoloc:
    """The Geoloc utility class"""

    def __init__(self, handpad: Display_Lite, coordinates: Coordinates_Lite) -> None:
        """Initializes

        Parameters:
        handpad (Display): The handpad that is connected to the eFinder
        coordinates (Coordinates): The coordinates utility class to be used in the eFinder
        """
        self.handpad = handpad
        self.aligned = False
        self.coordinates = coordinates
        self.long = 0
        self.lat = 0
        self.earth = coordinates.get_earth()
        self.ts = coordinates.get_ts()
        self.ser = serial.Serial('/dev/ttyS0',baudrate=9600)


    def getGps(self):
        while True:
            try:
                msg = self.ser.readline().decode('UTF-8', errors='ignore')
                if msg.startswith('$GNGGA'):
                    pkts = msg.split(',')
                    Elev = pkts[9]
                    qual = int(pkts[6])
                    if qual == 0:
                        print('Awaiting fix',c)
                        c = c + 1
                        continue
                    else:
                        print('gps fix acquired')
                        break
            except:
                print('acquiring gps fix')
            time.sleep(0.2)
        while True:
            try:
                msg = self.ser.readline().decode('UTF-8', errors='ignore')
                if  msg.startswith('$GNRMC'):
                    pkts = msg.split(',')
                    dateTime = ('20%s-%s-%sT%s:%s:%s.000Z' % (pkts[9][4:6],pkts[9][2:4],pkts[9][0:2],pkts[1][0:2],pkts[1][2:4],pkts[1][4:6]))
                    Lat = int(pkts[3][0:2])+float(pkts[3][2:])/60
                    if pkts[4] != 'N':
                        Lat = -Lat
                    Long = int(pkts[5][0:3])+float(pkts[5][3:])/60
                    if pkts[6] == 'W':
                        Long = - Long
                    break

            except:
                print('acquiring gps fix')
            time.sleep(0.2)
        print (dateTime,Lat,Long)
        return (dateTime,Lat,Long)

    def read(self) -> None:
        """Reads geodata from the GPS module"""
        
        dateTime,self.lat,self.long = self.getGps()
        print('Lat,Long', self.lat, self.long)
        self.location = self.coordinates.get_earth() + wgs84.latlon(self.lat, self.long)
        self.site = wgs84.latlon(self.lat,self.long)
        print('GPS reports UTC:',dateTime)
        dateTime = dateTime.replace('T',' ')
        dateTime = dateTime.replace('-','')
        print("setting pi clock to UTC")
        os.system('sudo date -u --set="%s"' % dateTime)
        self.handpad.display("GPS Data", "Acquired", "Datetime set")
        time.sleep(1)

    def altaz2Radec(self,az,alt):
        t = self.ts.now()
        a = self.location.at(t)
        pos = a.from_altaz(alt_degrees=alt,az_degrees=az)
        ra,dec,d = pos.radec()
        return ra.hours,dec.degrees
        
    def get_location(self):
        """Returns the location in space of the observer

        Returns:
        location: The location
        """
        return self.location
    
    def get_site(self):
        """Returns the location on earth of the observer

        Returns:
        location: The site
        """
        return self.site
    
    def get_long(self):
        """Returns the longitude of the observer

        Returns:
        long: The lonogitude
        """
        return self.long

    def get_lat(self):
        """Returns the latitude of the observer

        Returns:
        lat: The latitude
        """
        return self.lat
        
    def get_lunar_rates(self):
        t = self.ts.now()
        a = self.get_location().at(t).observe(self.moon).apparent()
        alt, az, distance, alt_rate, az_rate, range_rate = (a.frame_latlon_and_rates(self.site))
        ra,dec,d = a.radec()
        return (ra.hours,dec.degrees,alt.degrees,alt_rate.arcseconds.per_second,az_rate.arcseconds.per_second)
    
    def get_rate(self,ra,dec):
        t = self.ts.now()
        scope = Star(ra_hours = ra,dec_degrees = dec)
        a = self.get_location().at(t).observe(scope).apparent()
        alt, az, distance, alt_rate, az_rate, range_rate = (a.frame_latlon_and_rates(self.site))
        return (alt,az,alt_rate.arcseconds.per_second,az_rate.arcseconds.per_second)
