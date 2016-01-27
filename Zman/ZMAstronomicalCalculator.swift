//
//  ZMAstronomicalCalculator.swift
//  Zman
//
//  Created by Andrés Catalán on 2016–01–20.
//  Copyright © 2016 Ayre. All rights reserved.
//

import Foundation

/**
* An class that all sun time calculating classes inherit from. This allows the algorithm used to be changed at runtime, easily allowing comparison the results of using different algorithms. TODO: consider methods that would allow atmospheric modeling. This can currently be adjusted by setting the refraction.
 - author: &copy; Andrés Catalán (2016), based on the Java implementation by Eliyahu Hershfeld (2004 - 2013)
*/

class ZMAstronomicalCalculator {

    /**
     The commonly used average solar refraction value, to be used when calculating sunrise and sunset. The default value is 34 arc minutes. The <a href="http://emr.cs.iit.edu/home/reingold/calendar-book/second-edition/errata.pdf">Errata and Notes for Calendrical Calculations: The Millenium Eddition</a> by Edward M. Reingold and Nachum Dershowitz lists the actual average refraction value as 34.478885263888294 or approximately 34' 29". The refraction value as well as the solarRadius and elevation adjustment are added to the zenith used to calculate sunrise and sunset.
     */

    let refraction: Double = 34 / 60
//    let refraction: Double = 34.478885263888294 / 60
    
    /**
    The sun's radius in minutes of a degree. The default value is 16 arc minutes. The sun's radius as it appears from earth is almost universally given as 16 arc minutes but in fact it differs by the time of the year. At the [perihelion](http://en.wikipedia.org/wiki/Perihelion) it has an apparent radius of 16.293, while at the [aphelion](http://en.wikipedia.org/wiki/Aphelion) it has an apparent radius of 15.755. There is little effect for most location, but at high and low latitudes the difference becomes more apparent. My calculations for the difference at the location of the [Royal Observatory in Greenwich](http://www.rog.nmm.ac.uk) show only a 4.494 second difference between the perihelion and aphelion radii, but moving into the arctic circle the difference becomes more noticeable. Tests for Tromso, Norway (latitude 69.672312, longitude 19.049787) show that on May 17, the rise of the midnight sun, a 2 minute 23 second difference is observed between the perihelion and aphelion radii using the USNO algorithm, but only 1 minute and 6 seconds difference using the NOAA algorithm. Areas farther north show an even greater difference. Note that these test are not real valid test cases because they show the extreme difference on days that are not the perihelion or aphelion, but are shown for illustrative purposes only.
    */

    let solarRadius: Double = 16 / 60
    
    /**
    The commonly used average earth radius in Km. At this time, this only affects elevation adjustment and not the sunrise and sunset calculations. The value currently defaults to 6356.9 KM.
    */
    var earthRadius: Double = 6356.9 // in Km

    /**
    The zenith of astronomical sunrise and sunset. The sun is 90&deg; from the vertical 0&deg;
    */
    static let GeometricZenith: Double = 90

    /**
    Method to return the adjustment to the zenith required to account for the elevation. Since a person at a higher elevation can see farther below the horizon, the calculation for sunrise / sunset is calculated below the horizon used at sea level. This is only used for sunrise and sunset and not times before or after it such as nautical twilight since those calculations are based on the level of available light at the given dip below the horizon, something that is not affected by elevation, the adjustment should only made if the zenith == 90&deg; adjusted for refraction and solar radius.
    
    The algorithm used is:
    ```
     elevationAdjustment = acos(earthRadiusInMeters / (earthRadiusInMeters + elevationMeters)).toDegrees
    ```

    The source of this algorthitm is <a href="http://www.calendarists.com">Calendrical Calculations</a> by Edward M. Reingold and Nachum Dershowitz. An alternate algorithm that produces an almost identical (but not accurate) result found in Ma'aglay Tzedek by Moishe Kosower and other sources is:
    ```
     elevationAdjustment = 0.0347 * Math.sqrt(elevationMeters);
    ```
    - parameter elevation: Elevation in Meters.
    - returns: The adjusted zenith
    */
    func elevationAdjustment(elevation: Double) -> Double {
        let radius = earthRadius * 1000 // in meters
        return acos(radius / (radius + elevation)).toDegrees
        //return 0.0347 * sqrt(elevation)
    }

    /**
    Adjusts the zenith of astronomical sunrise and sunset to account for solar refraction, solar radius and elevation. The value for Sun's zenith and true rise/set Zenith (used in this class and subclasses) is the angle that the center of the Sun makes to a line perpendicular to the Earth's surface. If the Sun were a point and the Earth were without an atmosphere, true sunset and sunrise would correspond to a 90&deg; zenith. Because the Sun is not a point, and because the atmosphere refracts light, this 90&deg; zenith does not, in fact, correspond to true sunset or sunrise, instead the centre of the Sun's disk must lie just below the horizon for the upper edge to be obscured. This means that a zenith of just above 90&deg; must be used. The Sun subtends an angle of 16 minutes of arc, and atmospheric refraction accounts for 34 minutes or so, giving a total of 50 arcminutes. The total value for Zenigh is 90+(5/6) or 90.8333333&deg; for true sunrise/sunset. Since a person at an elevation can see blow the horizon of a person at sea level, this will also adjust the zenith to account for elevation if available.
    - parameter zenith: Zenith in degrees
    - parameter elevation: Elevation in meters
    - returns: The zenith adjusted to include the sun's radius, refraction and elevation adjustment. This will only be adjusted for sunrise and sunset (if the zenith == 90&deg;)
    */
    func adjustedZenith(zenith: Double, elevation: Double) -> Double {
        guard zenith != ZMAstronomicalCalculator.GeometricZenith else {
            return zenith + solarRadius + refraction + elevationAdjustment(elevation)
        }
        return zenith
    }
}