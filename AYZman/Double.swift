//
//  Double.swift
//  AYZman
//
//  Created by Andrés Catalán on 2016–01–11.
//  Copyright © 2016 Ayre. All rights reserved.
//

import Foundation

extension Double {
    var toRadians: Double {
        return self * M_PI / 180.0
    }
    var toDegrees: Double {
        return self * 180.0 / M_PI
    }
}