//
//  ZMHebrewMonth.swift
//  Zman
//
//  Created by Andrés Catalán on 2016–01–15.
//  Copyright © 2016 Ayre. All rights reserved.
//

import Foundation

/**
 Value of the month field indicating the months of the year in the Jewish calendar. It is defined with base zero starting in Nisan.
 
 With Nisan being given a raw value of 0 and the year starting at Tishrei, each month is actually the [(rawvalue + 7) % 13]th month of the year. If it is a Jewish leap year, it would actually be the [(rawvalue + 8) % 13]th. The leap years are years 3, 6, 8, 11, 14, 17 and 19 of a 19 year cycle.
 */
enum ZMHebrewMonth: Int, Comparable {
    case Nisan = 0, Iyyar, Sivan, Tamuz, Av, Elul, Tishrei, Cheshvan, Kislev, Tevet, Shvat, Adar, AdarII
    
    var string: String {
        switch self {
        case .Nisan:    return "Nisan"
        case .Iyyar:    return "Iyyar"
        case .Sivan:    return "Sivan"
        case .Tamuz:    return "Tamuz"
        case .Av:       return "Av"
        case .Elul:     return "Elul"
        case .Tishrei:  return "Tishrei"
        case .Cheshvan: return "Cheshvan"
        case .Kislev:   return "Kislev"
        case .Tevet:    return "Tevet"
        case .Shvat:    return "Sh'vat"
        case .Adar:     return "Adar"
        case .AdarII:   return "Adar II"
        }
    }
}

func < (lhs: ZMHebrewMonth, rhs: ZMHebrewMonth) -> Bool {
    return lhs.rawValue < rhs.rawValue
}
func <= (lhs: ZMHebrewMonth, rhs: ZMHebrewMonth) -> Bool {
    return lhs.rawValue <= rhs.rawValue
}
func > (lhs: ZMHebrewMonth, rhs: ZMHebrewMonth) -> Bool {
    return lhs.rawValue > rhs.rawValue
}
func >= (lhs: ZMHebrewMonth, rhs: ZMHebrewMonth) -> Bool {
    return lhs.rawValue >= rhs.rawValue
}

func + (lhs: ZMHebrewMonth, rhs: Int) -> ZMHebrewMonth {
    return ZMHebrewMonth(rawValue: (lhs.rawValue + rhs) % 13)!
}

func += (inout lhs: ZMHebrewMonth, rhs: Int) {
    lhs = lhs + rhs
}

