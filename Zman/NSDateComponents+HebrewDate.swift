//
//  NSDateComponents+HebrewDate.swift
//  Zman
//
//  Created by Andrés Catalán on 2016–01–21.
//  Copyright © 2016 Ayre. All rights reserved.
//

import Foundation

enum NSDateComponentsHebrewDateError: ErrorType {
    case NoCalendarIdentifier, NotHebrewCalendar
    case NoYear, NoMonth, NoDay, NoWeekday
    case InvalidDate
}

extension NSDateComponents {
    private func validateHebrewCalendar() throws {
        guard calendar != nil else {
            print("The calendar identifier is missing from the NSDateComponents object.")
            throw NSDateComponentsHebrewDateError.NoCalendarIdentifier
        }
        guard calendar?.calendarIdentifier == NSCalendarIdentifierHebrew else {
            print("The calendar of the NSDateComponents object is not Hebrew.")
            throw NSDateComponentsHebrewDateError.NotHebrewCalendar
        }
        guard year != NSDateComponentUndefined else {
            print("The year is missing from the NSDateComponents object.")
            throw NSDateComponentsHebrewDateError.NoYear
        }
        guard month != NSDateComponentUndefined else {
            print("The month is missing from the NSDateComponents object.")
            throw NSDateComponentsHebrewDateError.NoMonth
        }
        guard day != NSDateComponentUndefined else {
            print("The day is missing from the NSDateComponents object.")
            throw NSDateComponentsHebrewDateError.NoDay
        }
        guard weekday != NSDateComponentUndefined else {
            print("The weekday is missing from the NSDateComponents object.")
            throw NSDateComponentsHebrewDateError.NoWeekday
        }
        guard validDate else {
            print("The date is not valid.")
            throw NSDateComponentsHebrewDateError.InvalidDate
        }
    }
    var hebrewMonth: ZMHebrewMonth? {
        do {
            try validateHebrewCalendar()
        } catch NSDateComponentsHebrewDateError.NoDay {
        } catch NSDateComponentsHebrewDateError.NoWeekday {
        } catch {
            return nil
        }
        switch month {
        case 1, 2, 3, 4, 5, 6:
            return ZMHebrewMonth(rawValue: month + 5)!
        case 7:
            return isHebrewLeapYear ? .AdarII : .Adar
        case 8, 9, 10, 11, 12, 13:
            return ZMHebrewMonth(rawValue: (month + 5) % 13)!
        default:
            return nil
        }
    }
    public var isHebrewLeapYear: Bool {
        do {
            try validateHebrewCalendar()
        } catch NSDateComponentsHebrewDateError.NoMonth {
        } catch NSDateComponentsHebrewDateError.NoDay {
        } catch NSDateComponentsHebrewDateError.NoWeekday {
        } catch {
            return false
        }
        return ((7 * year) + 1) % 19 < 7
    }
    public var daysInHebrewYear: Int? {
        do {
            try validateHebrewCalendar()
        } catch NSDateComponentsHebrewDateError.NoMonth {
        } catch NSDateComponentsHebrewDateError.NoDay {
        } catch NSDateComponentsHebrewDateError.NoWeekday {
        } catch {
            return nil
        }
        let calendar = NSCalendar(identifier: NSCalendarIdentifierHebrew)!
        let components = NSDateComponents()
        components.calendar = calendar
        components.year = year
        components.month = 13
        components.day = 29
        let yearEnd = calendar.dateFromComponents(components)!
        return calendar.ordinalityOfUnit(.Day, inUnit: .Year, forDate: yearEnd)
    }
    private var isKislevShort: Bool {
        if let daysInHebrewYear = daysInHebrewYear {
            return daysInHebrewYear % 10 == 3
        } else {
            return false
        }
    }
    private var isCheshvanLong: Bool {
        if let daysInHebrewYear = daysInHebrewYear {
            return daysInHebrewYear % 10 == 5
        } else {
            return false
        }
    }
    public func jewishAlmanac(inIsrael inIsrael: Bool, modernHolidays: Bool) -> ZMJewishAlmanac {
        do {
            try validateHebrewCalendar()
        } catch {
            return .Undefined
        }
        if let hebrewMonth = hebrewMonth {
            switch hebrewMonth {
            case .Nisan:
                switch day {
                case 14:
                    return .ErevPesach
                case 15:
                    return .Pesach
                case 16:
                    return inIsrael ? .CholHaMoedPesach : .Pesach
                case 17, 18, 19, 20:
                    return .CholHaMoedPesach
                case 21:
                    return .Pesach
                case 22:
                    return inIsrael ? .NotYomTov : .Pesach
                case 26:
                    // If the 27th falls on a Friday
                    return modernHolidays && weekday == 5 ? .YomHaShoa : .NotYomTov
                case 27:
                    // If the 27th does not fall on a Sunday or a Friday
                    return modernHolidays && weekday != 1 && weekday != 6 ? .YomHaShoa : .NotYomTov
                case 28:
                    // If the 27th falls on a Sunday
                    return modernHolidays && weekday == 2 ? .YomHaShoa : .NotYomTov
                default:
                    return .NotYomTov
                }
            case .Iyyar:
                switch day {
                case 2:
                    switch weekday {
                    case 4:
                        return .YomHaZikaron
                    default:
                        return .NotYomTov
                    }
                case 3:
                    switch weekday {
                    case 4:
                        return .YomHaZikaron
                    case 5:
                        return .YomHaAtzmaut
                    default:
                        return .NotYomTov
                    }
                case 4:
                    switch weekday {
                    case 3:
                        return .YomHaZikaron
                    case 5:
                        return .YomHaAtzmaut
                    default:
                        return .NotYomTov
                    }
                case 5:
                    switch weekday {
                    case 2:
                        return .YomHaZikaron
                    case 4:
                        return .YomHaAtzmaut
                    default:
                        return .NotYomTov
                    }
                case 6:
                    switch weekday {
                    case 3:
                        return .YomHaAtzmaut
                    default:
                        return .NotYomTov
                    }
                case 14:
                    return .PesachSheni
                case 28:
                    return .YomYerushalayim
                default:
                    return .NotYomTov
                }
            case .Sivan:
                switch day {
                case 5:
                    return .ErevShavuot
                case 6:
                    return .Shavuot
                case 7:
                    return inIsrael ? .NotYomTov : .Shavuot
                default:
                    return .NotYomTov
                }
            case .Tamuz:
                switch day {
                case 17:
                    return weekday == 7 ? .NotYomTov : .TzomTamuz
                case 18:
                    return weekday == 1 ? .TzomTamuz : .NotYomTov
                default:
                    return .NotYomTov
                }
            case .Av:
                switch day {
                case 9:
                    return weekday == 7 ? .NotYomTov : .TishaBeAv
                case 10:
                    return weekday == 1 ? .TishaBeAv : .NotYomTov
                case 15:
                    return .TuBeAv
                default:
                    return .NotYomTov
                }
            case .Elul:
                switch day {
                case 29:
                    return .ErevRoshHashana
                default:
                    return .NotYomTov
                }
            case .Tishrei:
                switch day {
                case 1, 2:
                    return .RoshHashana
                case 3:
                    return weekday == 7 ? .NotYomTov : .TzomGedalia
                case 4:
                    return weekday == 1 ? .TzomGedalia : .NotYomTov
                case 9:
                    return .ErevYomKippur
                case 10:
                    return .YomKippur
                case 14:
                    return .ErevSukkot
                case 15:
                    return .Sukkot
                case 16:
                    return inIsrael ? .CholHaMoedSukkot : .Sukkot
                case 17, 18, 19, 20:
                    return .CholHaMoedSukkot
                case 21:
                    return .HoshanaRaba
                case 22:
                    return .SheminiAtzeret
                case 23:
                    return inIsrael ? .NotYomTov : .SimchatTorah
                default:
                    return .NotYomTov
                }
            case .Cheshvan:
                return .NotYomTov
            case .Kislev:
                switch day {
                case 24:
                    return .ErevHanuka
                case 25, 26, 27, 28, 29, 30:
                    return .Hanuka
                default:
                    return .NotYomTov
                }
            case .Tevet:
                switch day {
                case 1, 2:
                    return .Hanuka
                case 3:
                    return isKislevShort ? .Hanuka : .NotYomTov
                case 10:
                    return .AsaraBeTevet
                default:
                    return .NotYomTov
                }
            case .Shvat:
                switch day {
                case 15:
                    return .TuBishvat
                default:
                    return .NotYomTov
                }
            case .Adar:
                switch day {
                case 11, 12:
                    return !isHebrewLeapYear && weekday == 5 ? .TaanitEster : .NotYomTov
                case 13:
                    return !isHebrewLeapYear
                        && weekday != 6 && weekday != 7 ? .TaanitEster : .NotYomTov
                case 14:
                    return isHebrewLeapYear ? .PurimKatan : .Purim
                case 15:
                    return isHebrewLeapYear ? .ShushanPurimKatan : .ShushanPurim
                default:
                    return .NotYomTov
                }
            case .AdarII:
                switch day {
                case 11, 12:
                    return weekday == 5 ? .TaanitEster : .NotYomTov
                case 13:
                    return weekday != 6 && weekday != 7 ? .TaanitEster : .NotYomTov
                case 14:
                    return .Purim
                case 15:
                    return .ShushanPurim
                default:
                    return .NotYomTov
                }
            }
        }
        return .Undefined
    }
    public func isYomTov(inIsrael inIsrael: Bool, modernHolidays: Bool) -> Bool {
        let almanac = jewishAlmanac(inIsrael: inIsrael, modernHolidays: modernHolidays)
        if isErevYomTov {
            return false
        }
        if almanac == .Hanuka {
            return false
        }
        if isTaanit && almanac != .YomKippur {
            return false
        }
        return almanac != .NotYomTov
    }
    public func isCholHaMoed(inIsrael inIsrael: Bool) -> Bool {
        switch jewishAlmanac(inIsrael: inIsrael, modernHolidays: true) {
        case .CholHaMoedPesach, .CholHaMoedSukkot:
            return true
        default:
            return false
        }
    }
    public var isErevYomTov: Bool {
        switch jewishAlmanac(inIsrael: true, modernHolidays: true) {
        case .ErevPesach, .ErevShavuot, .ErevSukkot, .ErevRoshHashana, .ErevYomKippur:
            return true
        default:
            return false
        }
    }
    public var isTaanit: Bool {
        switch jewishAlmanac(inIsrael: true, modernHolidays: true) {
        case .TzomTamuz, .TishaBeAv, .TzomGedalia, .YomKippur, .AsaraBeTevet, .TaanitEster:
            return true
        default:
            return false
        }
    }
    public var isRoshHodesh: Bool {
        return (day == 1 && month != 13) || day == 30
    }
    public var isErevRoshHodesh: Bool {
        return day == 29 && month != 13
    }
    public var isHanuka: Bool {
        return jewishAlmanac(inIsrael: true, modernHolidays: true) == .Hanuka
    }
    public var dayOfHanuka: Int? {
        if isHanuka {
            switch hebrewMonth! {
            case .Kislev:
                return day - 24
            case .Tevet:
                return isKislevShort ? day + 5 : day + 6
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
