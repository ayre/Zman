//
//  ZMGeoLocation.swift
//  AYHebrewCalendar
//
//  Created by Andrés Catalán on 2015–12–28.
//  Copyright © 2015 Ayre. All rights reserved.
//
//  KosherJava equivalent: GeoLocation

import Foundation

  /// A class that contains location information such as latitude and longitude required for astronomical calculations. The elevation field may not be used by some calculation engines and would be ignored if set. Check the documentation for specific implementations of the {@link AstronomicalCalculator} to see if elevation is calculated as part of the algorithm.

public class ZMGeoLocation: NSObject {
    // TODO: Latitude cannot be >90 or <-90
    // TODO: The original code contains functions that calculate the latitude given DMS and direction
    let latitude: Double
    
    // TODO: Longitude cannot be >180 or <-180
    // TODO: The original code contains functions that calculate the longitude given DMS and direction
    let longitude: Double
    
    let locationName: String
    
    // TODO: Elevation cannot be <0
    let elevation: Double
    
    // TODO: The timeZone might need a listener: "setTimeZone(): Method to set the TimeZone. If this is ever set after the ZMGeoLocation is set in the AstronomicalCalendar, it is critical that getCalendar().setTimeZone(TimeZone) be called in order for the AstronomicalCalendar to output times in the expected offset. This situation will arise if the AstronomicalCalendar is ever cloned."
    let timeZone: NSTimeZone
    
     /// Constant for milliseconds in a minute (60,000)
    private let MillisecondsInAMinute: Double = 60 * 1000
    
     /// Constant for milliseconds in an hour (3,600,000)
    private let MillisecondsInAnHour: Double = 60 * 1000 * 60
 
    var localMeanTimeOffset: Double {
        /**
        *  A method that will return the location's local mean time offset in milliseconds from local <a href="http://en.wikipedia.org/wiki/Standard_time">standard time</a>. The globe is split into 360&deg;, with 15&deg; per hour of the day. For a local that is at a longitude that is evenly divisible by 15 (longitude % 15 == 0), at solar {@link net.sourceforge.zmanim.AstronomicalCalendar#getSunTransit() noon} (with adjustment for the <a href="http://en.wikipedia.org/wiki/Equation_of_time">equation of time</a>) the sun should be directly overhead, so a user who is 1&deg; west of this will have noon at 4 minutes after standard time noon, and conversely, a user who is 1&deg; east of the 15&deg; longitude will have noon at 11:56 AM. Lakewood, N.J., whose longitude is -74.2094, is 0.7906 away from the closest multiple of 15 at -75&deg;. This is multiplied by 4 to yield 3 minutes and 10 seconds earlier than standard time. The offset returned does not account for the <a href="http://en.wikipedia.org/wiki/Daylight_saving_time">Daylight saving time</a> offset since this class is unaware of dates.
        */
        get {
            return longitude * 4 * MillisecondsInAMinute - Double(timeZone.secondsFromGMT * 1000)
        }
    }
    
    // MARK: - Initializers
    
    /**
    ZMGeoLocation full constructor with parameters for all required fields.
    - parameter locationName: The location name for display use such as "Lakewood, NJ"
    - parameter latitude:     The latitude in a double format such as 40.095965 for Lakewood, NJ
    
      **Note:** For latitudes south of the equator, a negative value should be used.
    - parameter longitude:    Double the longitude in a double format such as -74.222130 for Lakewood, NJ.
    
      **Note:** For longitudes east of the [Prime Meridian](http://en.wikipedia.org/wiki/Prime_Meridian) (Greenwich), a negative value should be used.
    - parameter elevation:    The elevation above sea level in Meters. Elevation is not used in most algorithms used for calculating sunrise and set.
    - parameter timeZone:     The ``TimeZone`` for the location.
    - returns: A ZMGeoLocation object initialized with the required fields set to the values of the parameters.
    - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
    - version: 1.1
    */
    
    public init(locationName: String, latitude: Double, longitude: Double, elevation: Double, timeZone: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        self.elevation = elevation
        self.timeZone = NSTimeZone(name: timeZone)!
    }
    
    /**
     ZMGeoLocation convenience constructor with parameters for all required fields except for elevation.
     - parameter locationName: The location name for display use such as "Lakewood, NJ"
     - parameter latitude:     The latitude in a double format such as 40.095965 for Lakewood, NJ
     
     **Note:** For latitudes south of the equator, a negative value should be used.
     - parameter longitude:    Double the longitude in a double format such as -74.222130 for Lakewood, NJ.
     
     **Note:** For longitudes east of the [Prime Meridian](http://en.wikipedia.org/wiki/Prime_Meridian) (Greenwich), a negative value should be used.
     - parameter timeZone:     The ``TimeZone`` for the location.
     - returns: A ZMGeoLocation object initialized with the required fields set to the values of the parameters and an elevation of zero meters.
     - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
     - version: 1.1
     */
    convenience public init(locationName: String, latitude: Double, longitude: Double, timeZone: String) {
        self.init(locationName: locationName, latitude: latitude, longitude: longitude, elevation: 0, timeZone: timeZone)
    }
    
     /**
     Default ZMGeoLocation constructor will set location to the Prime Meridian at Greenwich, England and a TimeZone of GMT. The longitude will be set to 0 and the latitude will be 51.4772 to match the location of the [Royal Observatory, Greenwich](http://www.rog.nmm.ac.uk). No daylight savings time will be used.
     - returns: A ZMGeoLocation object initialized with the location of the [Royal Observatory, Greenwich](http://www.rog.nmm.ac.uk).
     - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
     - version: 1.1
     */
    
    convenience override public init() {
        self.init(locationName: "Greenwich, England", latitude: 51.4772, longitude: 0.0, timeZone: "GMT")
    }
}

// MARK: - Geodesic calculations

extension ZMGeoLocation {
    /**
     Calculate the initial [geodesic](https://en.wikipedia.org/wiki/Great_circle) bearing between this ZMGeoLocation object and a second ZMGeoLocation object passed to this method, using [Thaddeus Vincenty](http://en.wikipedia.org/wiki/Thaddeus_Vincenty)'s inverse formula
     - parameter location: The destination location.
     - returns: The initial bearing between this object's location and ``location``, according to Vincenty's formula.
     - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
     - version: 1.1
     - seealso: T Vincenty, "[Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations](http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf)", Survey Review, vol XXII no 176, 1975
     */
    
    func geodesicInitialBearingTo(location: ZMGeoLocation) -> Double {
        return ZMGeodesic.initialBearingFrom(self, to: location)
    }
    
    /**
     Calculate the final [geodesic](https://en.wikipedia.org/wiki/Great_circle) bearing between this ZMGeoLocation object and a second ZMGeoLocation object passed to this method, using [Thaddeus Vincenty](http://en.wikipedia.org/wiki/Thaddeus_Vincenty)'s inverse formula
     - parameter location: The destination location.
     - returns: The final bearing between this object's location and ``location``, according to Vincenty's formula.
     - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
     - version: 1.1
     - seealso: T Vincenty, "[Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations](http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf)", Survey Review, vol XXII no 176, 1975
     */
    
    func geodesicFinalBearingTo(location: ZMGeoLocation) -> Double {
        return ZMGeodesic.finalBearingFrom(self, to: location)
    }
    
    /**
     Calculate [geodesic distance](http://en.wikipedia.org/wiki/Great-circle_distance) in meters between this ZMGeoLocation object and a second ZMGeoLocation object passed to this method, using [Thaddeus Vincenty](http://en.wikipedia.org/wiki/Thaddeus_Vincenty)'s inverse formula
     - parameter location: The destination location.
     - returns: The geodesic distance in meters between this object's location and ``location``, according to Vincenty's formula.
     - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
     - version: 1.1
     - seealso: T Vincenty, "[Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations](http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf)", Survey Review, vol XXII no 176, 1975
     */
    
    func geodesicDistanceTo(location: ZMGeoLocation) -> Double {
        return ZMGeodesic.distanceFrom(self, to: location)
    }
}


// MARK: - Equatable
    
func ==(lhs: ZMGeoLocation, rhs: ZMGeoLocation) -> Bool {
    return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.elevation == rhs.elevation && lhs.timeZone == rhs.timeZone && lhs.locationName == rhs.locationName
}

