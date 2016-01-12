//
//  ZMGeodesic.swift
//  AYHebrewCalendar
//
//  Created by Andrés Catalán on 2016–01–11.
//  Copyright © 2016 Ayre. All rights reserved.
//
//  KosherJava equivalent: zmanim.util.GeoLocationUtil

import Foundation

class ZMGeodesic: NSObject {
    
    /**
     Operating modes of the ``vincentyFormula`` function.
     - Distance:       Returns the distance between the two locations.
     - InitialBearing: Returns the initial bearing.
     - FinalBearing:   Returns the final bearing.
     */
    enum Formula {
        case Distance
        case InitialBearing
        case FinalBearing
    }

    /**
    Calculate [geodesic distance](http://en.wikipedia.org/wiki/Great-circle_distance) in meters between this ZMGeoLocation object and a second ZMGeoLocation object passed to this method, using [Thaddeus Vincenty](http://en.wikipedia.org/wiki/Thaddeus_Vincenty)'s inverse formula
    - parameter location: The initial location.
    - parameter destination: The destination location.
    - parameter formula: It indicates if the output of the formula should be the initial bearing (``.InitialBearing``), the final bearing (``.FinalBearing``) or the distance (``.Distance``).
    - returns: The geodesic distance in meters or bearings between ``location`` and ``destination``, according to Vincenty's formula.
    - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
    - version: 1.1
    - seealso: T Vincenty, "[Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations](http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf)", Survey Review, vol XXII no 176, 1975
    */
    private static func vincentyFormulaFrom(location: ZMGeoLocation, to destination: ZMGeoLocation, formula: Formula) -> Double {
        let a: Double = 6378137
        let b: Double = 6356752.3142
        let f: Double = 1 / 298.257223563; // WGS-84 ellipsiod
        let L: Double = (destination.longitude - location.longitude).toRadians
        let U1: Double = atan((1 - f) * tan(location.latitude.toRadians))
        let U2: Double = atan((1 - f) * tan(destination.latitude.toRadians))
        let sinU1: Double = sin(U1)
        let cosU1: Double = cos(U1)
        let sinU2: Double = sin(U2)
        let cosU2: Double = cos(U2)
        
        let iterLimit: Int = 20
        let tolerance: Double = 1e-12
        
        var lambda: Double = L
        var lambdaP: Double = 2 * M_PI
        var sinLambda: Double = 0
        var cosLambda: Double = 0
        var sinSigma: Double = 0
        var cosSigma: Double = 0
        var sigma: Double = 0
        var sinAlpha: Double = 0
        var cosSqAlpha: Double = 0
        var cos2SigmaM: Double = 0
        var C: Double = 0

        for i in 0...iterLimit {
            if abs(lambda - lambdaP) <= tolerance {
                break // a value has been found
            } else if i == iterLimit {
                return Double.NaN // formula failed to converge
            } else {
                sinLambda = sin(lambda)
                cosLambda = cos(lambda)
                sinSigma = sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) + (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda))
                if sinSigma == 0 {
                    return 0 // co-incident points
                }
                cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda
                sigma = atan2(sinSigma, cosSigma)
                sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma
                cosSqAlpha = 1 - sinAlpha * sinAlpha
                cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha
                if cos2SigmaM.isInfinite {
                    cos2SigmaM = 0 // equatorial line: cosSqAlpha=0
                }
                C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha))
                lambdaP = lambda
                lambda = L + (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)))
            }
        }
        let uSq: Double = cosSqAlpha * (a * a - b * b) / (b * b)
        let A: Double = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)))
        let B: Double = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)))
        let deltaSigma: Double = B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)))
        let distance: Double = b * A * (sigma - deltaSigma)
        
        // initial bearing
        let fwdAz: Double = atan2(cosU2 * sinLambda, cosU1 * sinU2 - sinU1 * cosU2 * cosLambda).toDegrees
        // final bearing
        let revAz: Double = atan2(cosU1 * sinLambda, -sinU1 * cosU2 + cosU1 * sinU2 * cosLambda).toDegrees
        
        switch formula {
        case .Distance:
            return distance
        case .InitialBearing:
            return fwdAz
        case .FinalBearing:
            return revAz
        }
    }
    
    /**
     Calculate the initial [geodesic](https://en.wikipedia.org/wiki/Great_circle) bearing between this ZMGeoLocation object and a second ZMGeoLocation object passed to this method, using [Thaddeus Vincenty](http://en.wikipedia.org/wiki/Thaddeus_Vincenty)'s inverse formula
     - parameter location: The initial location.
     - parameter destination: The destination location.
     - returns: The initial bearing between ``location`` and ``destination``, according to Vincenty's formula.
     - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
     - version: 1.1
     - seealso: T Vincenty, "[Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations](http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf)", Survey Review, vol XXII no 176, 1975
     */
    static func initialBearingFrom(location: ZMGeoLocation, to destination: ZMGeoLocation) -> Double {
        return vincentyFormulaFrom(location, to: destination, formula: .InitialBearing)
    }
    
    /**
     Calculate the final [geodesic](https://en.wikipedia.org/wiki/Great_circle) bearing between this ZMGeoLocation object and a second ZMGeoLocation object passed to this method, using [Thaddeus Vincenty](http://en.wikipedia.org/wiki/Thaddeus_Vincenty)'s inverse formula
     - parameter location: The initial location.
     - parameter destination: The destination location.
     - returns: The final bearing between ``location`` and ``destination``, according to Vincenty's formula.
     - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
     - version: 1.1
     - seealso: T Vincenty, "[Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations](http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf)", Survey Review, vol XXII no 176, 1975
     */
    static func finalBearingFrom(location: ZMGeoLocation, to destination: ZMGeoLocation) -> Double {
        return vincentyFormulaFrom(location, to: destination, formula: .FinalBearing)
    }
    
    /**
     Calculate [geodesic distance](http://en.wikipedia.org/wiki/Great-circle_distance) in meters between this ZMGeoLocation object and a second ZMGeoLocation object passed to this method, using [Thaddeus Vincenty](http://en.wikipedia.org/wiki/Thaddeus_Vincenty)'s inverse formula
     - parameter location: The initial location.
     - parameter destination: The destination location.
     - returns: The geodesic distance in meters between ``location`` and ``destination``, according to Vincenty's formula.
     - authors: (c) Eliyahu Hershfeld (2004 - 2012, original code in Java) and (c) Andrés Catalán (2016, Swift implementation)
     - version: 1.1
     - seealso: T Vincenty, "[Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations](http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf)", Survey Review, vol XXII no 176, 1975
     */
    static func distanceFrom(location: ZMGeoLocation, to destination: ZMGeoLocation) -> Double {
        return vincentyFormulaFrom(location, to: destination, formula: .Distance)
    }
    
     /**
     Returns the [rhumb line](http://en.wikipedia.org/wiki/Rhumb_line) bearing from ``location`` to ``destination``.
     - parameter location: The initial location.
     - parameter destination: The destination location.
     - returns: The rhumb line bearing in degrees between ``location`` and ``destination``.
     - see: Code ported from [Chris Veness' Javascript Implementation](http://www.movable-type.co.uk/scripts/latlong.html)
     - version: 1.1
     - seealso: T Vincenty, "[Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations](http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf)", Survey Review, vol XXII no 176, 1975
     */
    static func rhumbLineBearing(location: ZMGeoLocation, destination: ZMGeoLocation) -> Double {
        var dLon: Double = (destination.longitude - location.longitude).toRadians
        let dPhi: Double = log(tan(destination.latitude.toRadians / 2 + M_PI_4) / tan(location.latitude.toRadians / 2 + M_PI_4))
        if abs(dLon) > M_PI {
            dLon = dLon > 0 ? -(2 * M_PI - dLon) : (2 * M_PI + dLon)
        }
        return atan2(dLon, dPhi).toDegrees

    }
    
     /**
     Returns the [rhumb line](http://en.wikipedia.org/wiki/Rhumb_line) distance from ``location`` to ``destination``.
     - parameter location: The initial location.
     - parameter destination: The destination location.
     - returns: The distance in meters between ``location`` and ``destination``.
     - see: Code ported from [Chris Veness' Javascript Implementation](http://www.movable-type.co.uk/scripts/latlong.html)
     - version: 1.1
     - seealso: T Vincenty, "[Direct and Inverse Solutions of Geodesics on the Ellipsoid with application of nested equations](http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf)", Survey Review, vol XXII no 176, 1975
     */
    static func rhumbLineDistance(location: ZMGeoLocation, destination: ZMGeoLocation) -> Double {
        let R: Double = 6371 // earth's mean radius in km
        let dLat: Double = (destination.latitude - location.latitude).toRadians
        var dLon: Double = abs(destination.longitude - location.longitude).toRadians
        let dPhi: Double = log(tan(destination.latitude.toRadians / 2 + M_PI_4) / tan(location.latitude.toRadians / 2 + M_PI_4))
        let q: Double = abs(dLat) > 1e-10 ? dLat / dPhi : cos(location.latitude.toRadians)
        // If dLon over 180� take shorter rhumb across 180� meridian:
        if dLon > M_PI {
            dLon = 2 * M_PI - dLon
        }
        let d: Double = sqrt(dLat * dLat + q * q * dLon * dLon)
        return d * R
    }

    
}