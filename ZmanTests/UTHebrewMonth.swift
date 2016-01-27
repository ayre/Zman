//
//  UTHebrewMonth.swift
//  Zman
//
//  Created by Andrés Catalán on 2016–01–17.
//  Copyright © 2016 Ayre. All rights reserved.
//

import XCTest
@testable import Zman

class UTHebrewMonth: XCTestCase {
    
    var nisan = ZMHebrewMonth.Nisan
    let iyyar = ZMHebrewMonth.Iyyar
    var adar = ZMHebrewMonth.Adar

    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testComparable_Lesser_valid() {
        XCTAssertTrue(nisan < iyyar)
    }

    func testComparable_LesserEqual_valid() {
        XCTAssertTrue(nisan <= iyyar)
    }
    
    func testComparable_Equal_valid() {
        XCTAssertTrue(nisan == nisan)
    }
    
    func testComparable_NotEqual_valid() {
        XCTAssertTrue(nisan != iyyar)
    }
    
    func testComparable_GreaterEqual_valid() {
        XCTAssertTrue(iyyar >= nisan)
    }
    
    func testComparable_Greater_valid() {
        XCTAssertTrue(iyyar > nisan)
    }
    
    func testComparable_Greater_invalid() {
        XCTAssertFalse(nisan > iyyar)
    }
    
    func testComparable_GreaterEqual_invalid() {
        XCTAssertFalse(nisan >= iyyar)
    }
    
    func testComparable_Equal_invalid() {
        XCTAssertFalse(nisan == iyyar)
    }
    
    func testComparable_NotEqual_invalid() {
        XCTAssertFalse(nisan != nisan)
    }
    
    func testComparable_LesserEqual_invalid() {
        XCTAssertFalse(iyyar <= nisan)
    }
    
    func testComparable_Lesser_invalid() {
        XCTAssertFalse(iyyar < nisan)
    }

    func testSumInteger_plusOne() {
        XCTAssertEqual(nisan + 1, iyyar)
    }

    func testSumInteger_overflow() {
        XCTAssertEqual(adar + 2, nisan)
    }
    
    func testSumAllocateInteger_plusOne() {
        nisan += 1
        XCTAssertEqual(nisan, iyyar)
    }
    
    func testSumAllocateInteger_overflow() {
        adar += 2
        XCTAssertEqual(adar, nisan)
    }

}
