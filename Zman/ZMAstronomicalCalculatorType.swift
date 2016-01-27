//
//  ZMAstronomicalCalculatorType.swift
//  Zman
//
//  Created by Andrés Catalán on 2016–01–20.
//  Copyright © 2016 Ayre. All rights reserved.
//

import Foundation

/**
 * A protocol that all sun time calculating classes implement. This allows the algorithm used to be changed at runtime, easily allowing comparison the results of using different algorithms. TODO: consider methods that would allow atmospheric modeling. This can currently be adjusted by setting the refraction.
 - author: &copy; Andrés Catalán (2016), based on the Java implementation by Eliyahu Hershfeld (2004 - 2013)
 */

protocol ZMAstronomicalCalculatorType {
    /**
    The descriptive name of the algorithm.
    */
    var calculatorName: String { get }
    /**
    A method that calculates UTC sunrise as well as any time based on an angle above or below sunrise. This abstract method is implemented by the classes that extend this class.
    - parameter date: Used to calculate day of year.
    - parameter geoLocation: The location information used for astronomical calculating sun times.
    - parameter zenith: The azimuth below the vertical zenith of 90 degrees. For sunrise typically the zenith used for the calculation uses geometric zenith of 90&deg; and adjusts this slightly to account for solar refraction and the sun's radius. Another example would be passing the nautical zenith to this method.
    - returns: The UTC time of sunrise in 24 hour format. 5:45:00 AM will return 5.75.0. If an error was encountered in the calculation (expected behavior for some locations such as near the poles, `nil` will be returned.
    */
    func UTCSunrise(date: ZMGregorianDate, geoLocation: ZMGeoLocation, zenith: Double, adjustForElevation: Bool) -> Double?

    /**
    A method that calculates UTC sunset as well as any time based on an angle above or below sunset. This abstract method is implemented by the classes that extend this class.
    - parameter date: Used to calculate day of year.
    - parameter geoLocation: The location information used for astronomical calculating sun times.
    - parameter zenith: The azimuth below the vertical zenith of 90 degrees. For sunset typically the zenith used for the calculation uses geometric zenith of 90&deg; and adjusts this slightly to account for solar refraction and the sun's radius. Another example would be passing the nautical zenith to this method.
    - returns: The UTC time of sunset in 24 hour format. 5:45:00 AM will return 5.75.0. If an error was encountered in the calculation (expected behavior for some locations such as near the poles, `nil` will be returned.
    */
    func UTCSunset(date: ZMGregorianDate, geoLocation: ZMGeoLocation, zenith: Double, adjustForElevation: Bool) -> Double?
}