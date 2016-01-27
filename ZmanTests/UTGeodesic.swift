//
//  UTGeodesic.swift
//  Zman
//
//  Created by Andrés Catalán on 2016–01–11.
//  Copyright © 2016 Ayre. All rights reserved.
//

import XCTest
@testable import Zman

class UTGeodesic: XCTestCase {
    // Arrange
    var observatory: ZMGeoLocation!
    var lakewood: ZMGeoLocation!
    
    override func setUp() {
        super.setUp()
        observatory = ZMGeoLocation()
        lakewood = ZMGeoLocation(locationName: "Lakewood, NJ", latitude: 40.095965, longitude: -74.222130, timeZone: "America/New_York")
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGeodesics_toSelf() {
        // Act
        let distance = observatory.geodesicDistanceTo(observatory)
        let initial = observatory.geodesicInitialBearingTo(observatory)
        let final = observatory.geodesicFinalBearingTo(observatory)

        // Assert
        XCTAssertEqual(distance, 0)
        XCTAssertEqual(initial, 0)
        XCTAssertEqual(final, 0)
    }

    func testGeodesics_GreenwichToLakewood() {
        // Act
        let distance = observatory.geodesicDistanceTo(lakewood)
        let initial = observatory.geodesicInitialBearingTo(lakewood)
        let final = observatory.geodesicFinalBearingTo(lakewood)
        
        // Assert
        XCTAssertEqualWithAccuracy(distance, 5652064.801265
, accuracy: 1e-6)
        XCTAssertEqualWithAccuracy(initial, -72.013457, accuracy: 1e-6)
        XCTAssertEqualWithAccuracy(final, -129.203109, accuracy: 1e-6)
    }

}
