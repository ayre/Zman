//
//  NSDateComponents+Zman.swift
//  Zman
//
//  Created by Andrés Catalán on 2016–01–26.
//  Copyright © 2016 Ayre. All rights reserved.
//

import Foundation

enum NSDateComponentsZmanError: ErrorType {
}

extension NSDateComponents {
    var chalakim: Int {
        guard second != NSDateComponentUndefined else {
            return NSDateComponentUndefined
        }
        guard nanosecond != NSDateComponentUndefined else {
            return Int(floor(Double(second) * 18.0 / 60.0))
        }
        return Int(floor((Double(second) + (Double(nanosecond)/1_000_000_000.0)) * 18.0 / 60.0))
    }
}
