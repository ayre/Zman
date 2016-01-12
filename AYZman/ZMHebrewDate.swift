//
//  ZMHebrewDate.swift
//  AYZman
//
//  Created by Andrés Catalán on 2016–01–11.
//  Copyright © 2016 Ayre. All rights reserved.
//
//  KosherJava equivalent: JewishDate

import Foundation

/**
 Months of the Hebrew year
 */
enum HebrewMonth: Int {
    case Nisan = 1, Iyyar, Sivan, Tamuz, Av, Elul, Tishrei, Cheshvan, Kislev, Tevet, Shvat, Adar, AdarII
}

enum Weekday: Int {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

struct Molad {
    var hours: Int
    var minutes: Int
    var chalakim: Int
}

public struct ZMHebrewDate {
    
    internal static let JewishEpoch: Int = -1373429
    internal static let ChalakimPerMinute: Int = 18
    internal static let ChalakimPerHour: Int = 60 * 18 // 1080
    internal static let ChalakimPerDay: Int = 24 * 1080 // 25920
    internal static let ChalakimPerMonth: Int = (29 * 24 + 12) * 1080 + 793 //765433
    
    /**
    * Days from the beginning of Sunday till molad BaHaRaD. Calculated as 1 day, 5 hours and 204 chalakim = (24 + 5) * 1080 + 204 = 31524
    */
    internal static let ChalakimMoladTohu: Int = 31524;

    enum HebrewYearType {
        // A short year where both Cheshvan and Kislev are 29 days.
        case Chaserim
        // An ordered year where Cheshvan is 29 days and Kislev is 30 days.
        case Kesidran
        // A long year where both Cheshvan and Kislev are 30 days.
        case Shelaimim
    }

    let molad: Molad
    
    var day: Int
    var month: HebrewMonth
    var year: Int
    
    let gregorianDate: ZMGregorianDate
    let dayOfWeek: Weekday
    
    static func isLeapYear(year: Int) -> Bool {
        return ((7 * year) + 1) % 19 < 7
    }
    
    func isLeapYear() -> Bool {
        return ZMHebrewDate.isLeapYear(self.year)
    }

    static func lastMonthOfYear(year: Int) -> HebrewMonth {
        return ZMHebrewDate.isLeapYear(year) ? .AdarII : .Adar
    }

    static func addDechiyot(year: Int, moladDay: Int, moladParts: Int) -> Int {
        var roshHashanaDay = moladDay
        
        // Molad Zaken - If the molad of Tishrei falls after 12 noon, Rosh Hashana is delayed to the following day. If the following day is ADU, it will be delayed an additional day.
        let dechiyaMoladZaken = moladParts >= 19440
        
        // GaTRaD - If on a non leap year the molad of Tishrei falls on a Tuesday (Ga) on or after 9 hours (T) and 204 chalakim (TRaD) it is delayed till Thursday (one day delay, plus one day for Lo ADU Rosh)
        let dechiyaGatrad = (moladDay % 7) == 2 && moladParts >= 9924 && !ZMHebrewDate.isLeapYear(year)
        
        // BeTuTaKFoT - if the year following a leap year falls on a Monday (Be) on or after 15 hours (Tu) and 589 chalakim (TaKFoT) it is delayed till Tuesday
        let dechiyaBetutakfot = (moladDay % 7) == 1 && moladParts >= 16789 && ZMHebrewDate.isLeapYear(year - 1)
        
        if dechiyaBetutakfot || dechiyaGatrad || dechiyaMoladZaken {
            roshHashanaDay += 1
        }
        
        // Lo ADU Rosh - Rosh Hashana can't fall on a Sunday, Wednesday or Friday. If the molad fell on one of these days, Rosh Hashana is delayed to the following day.
        let dechiyaLoAduRosh = (roshHashanaDay % 7) == 0 || (roshHashanaDay % 7) == 3  || (roshHashanaDay % 7) == 5
        
        if dechiyaLoAduRosh {
            roshHashanaDay += 1
        }
        
        return roshHashanaDay
    }
    
    static func monthOrdinal(year: Int, month: HebrewMonth) -> Int {
        switch ZMHebrewDate.isLeapYear(year) {
        case true:
            return (month.rawValue + 6) % 13 + 1
        case false:
            return (month.rawValue + 5) % 12 + 1
        }
    }
    
    static func chalakimSinceMoladTohu(year year: Int, month: HebrewMonth) -> Int {
        let monthOrdinal = ZMHebrewDate.monthOrdinal(year, month: month)
        let monthsElapsed = (235 * ((year - 1) / 19)) + (12 * ((year - 1) % 19)) + ((7 * ((year - 1) % 19) + 1) / 19) + (monthOrdinal - 1)
        return ChalakimMoladTohu + ChalakimPerMonth * monthsElapsed
    }
    
    func chalakimSinceMoladTohu() -> Int {
        return ZMHebrewDate.chalakimSinceMoladTohu(year: self.year, month: self.month)
    }
    
    static func elapsedDays(year: Int) -> Int {
        let chalakimSince: Int = chalakimSinceMoladTohu(year: year, month: .Tishrei);
        let moladDay: Int = chalakimSince / ChalakimPerDay
        let moladParts: Int = chalakimSince - moladDay * ChalakimPerDay;
        return addDechiyot(year, moladDay: moladDay, moladParts: moladParts)
    }

}

//    /**
//    * Returns the number of days for a given Jewish year. ND+ER
//    *
//    * @param year
//    *            the Jewish year
//    * @return the number of days for a given Jewish year.
//    * @see #isCheshvanLong()
//    * @see #isKislevShort()
//    */
//    public static int getDaysInJewishYear(int year) {
//        return getJewishCalendarElapsedDays(year + 1) - getJewishCalendarElapsedDays(year);
//    }
//
//    /**
//    * Returns the number of days for the current year that the calendar is set to.
//    *
//    * @see #isCheshvanLong()
//    * @see #isKislevShort()
//    * @see #isJewishLeapYear()
//    */
//    public int getDaysInJewishYear() {
//        return getDaysInJewishYear(getJewishYear());
//    }
//
//    /**
//    * Returns if Cheshvan is long in a given Jewish year. The method name isLong is done since in a Kesidran (ordered)
//    * year Cheshvan is short. ND+ER
//    *
//    * @param year
//    *            the year
//    * @return true if Cheshvan is long in Jewish year.
//    * @see #isCheshvanLong()
//    * @see #getCheshvanKislevKviah()
//    */
//    private static boolean isCheshvanLong(int year) {
//        return getDaysInJewishYear(year) % 10 == 5;
//    }
//
//    /**
//    * Returns if Cheshvan is long (30 days VS 29 days) for the current year that the calendar is set to. The method
//    * name isLong is done since in a Kesidran (ordered) year Cheshvan is short.
//    *
//    * @return true if Cheshvan is long for the current year that the calendar is set to
//    * @see #isCheshvanLong()
//    */
//    public boolean isCheshvanLong() {
//        return isCheshvanLong(getJewishYear());
//    }
//
//    /**
//    * Returns if Kislev is short (29 days VS 30 days) in a given Jewish year. The method name isShort is done since in
//    * a Kesidran (ordered) year Kislev is long. ND+ER
//    *
//    * @param year
//    *            the Jewish year
//    * @return true if Kislev is short for the given Jewish year.
//    * @see #isKislevShort()
//    * @see #getCheshvanKislevKviah()
//    */
//    private static boolean isKislevShort(int year) {
//        return getDaysInJewishYear(year) % 10 == 3;
//    }
//
//    /**
//    * Returns if the Kislev is short for the year that this class is set to. The method name isShort is done since in a
//    * Kesidran (ordered) year Kislev is long.
//    *
//    * @return true if Kislev is short for the year that this class is set to
//    */
//    public boolean isKislevShort() {
//        return isKislevShort(getJewishYear());
//    }
//
//    /**
//    * Returns the Cheshvan and Kislev kviah (whether a Jewish year is short, regular or long). It will return
//    * {@link #SHELAIMIM} if both cheshvan and kislev are 30 days, {@link #KESIDRAN} if Cheshvan is 29 days and Kislev
//    * is 30 days and {@link #CHASERIM} if both are 29 days.
//    *
//    * @return {@link #SHELAIMIM} if both cheshvan and kislev are 30 days, {@link #KESIDRAN} if Cheshvan is 29 days and
//    *         Kislev is 30 days and {@link #CHASERIM} if both are 29 days.
//    * @see #isCheshvanLong()
//    * @see #isKislevShort()
//    */
//    public int getCheshvanKislevKviah() {
//        if (isCheshvanLong() && !isKislevShort()) {
//            return SHELAIMIM;
//        } else if (!isCheshvanLong() && isKislevShort()) {
//            return CHASERIM;
//        } else {
//            return KESIDRAN;
//        }
//    }
//
//    /**
//    * Returns the number of days of a Jewish month for a given month and year.
//    *
//    * @param month
//    *            the Jewish month
//    * @param year
//    *            the Jewish Year
//    * @return the number of days for a given Jewish month
//    */
//    private static int getDaysInJewishMonth(int month, int year) {
//        if ((month == IYAR) || (month == TAMMUZ) || (month == ELUL) || ((month == CHESHVAN) && !(isCheshvanLong(year)))
//            || ((month == KISLEV) && isKislevShort(year)) || (month == TEVES)
//            || ((month == ADAR) && !(isJewishLeapYear(year))) || (month == ADAR_II)) {
//                return 29;
//        } else {
//            return 30;
//        }
//    }
//
//    /**
//    * Returns the number of days of the Jewish month that the calendar is currently set to.
//    *
//    * @return the number of days for the Jewish month that the calendar is currently set to.
//    */
//    public int getDaysInJewishMonth() {
//        return getDaysInJewishMonth(getJewishMonth(), getJewishYear());
//    }
//
//    /**
//    * Computes the Jewish date from the absolute date. ND+ER
//    */
//    private void absDateToJewishDate() {
//        // Approximation from below
//        jewishYear = (gregorianAbsDate + JEWISH_EPOCH) / 366;
//        // Search forward for year from the approximation
//        while (gregorianAbsDate >= jewishDateToAbsDate(jewishYear + 1, TISHREI, 1)) {
//            jewishYear++;
//        }
//        // Search forward for month from either Tishri or Nisan.
//        if (gregorianAbsDate < jewishDateToAbsDate(jewishYear, NISSAN, 1)) {
//            jewishMonth = TISHREI;// Start at Tishri
//        } else {
//            jewishMonth = NISSAN;// Start at Nisan
//        }
//        while (gregorianAbsDate > jewishDateToAbsDate(jewishYear, jewishMonth, getDaysInJewishMonth())) {
//            jewishMonth++;
//        }
//        // Calculate the day by subtraction
//        jewishDay = gregorianAbsDate - jewishDateToAbsDate(jewishYear, jewishMonth, 1) + 1;
//    }
//
//    /**
//    * Returns the absolute date of Jewish date. ND+ER
//    *
//    * @param year
//    *            the Jewish year. The year can't be negative
//    * @param month
//    *            the Jewish month starting with Nisan. Nisan expects a value of 1 etc till Adar with a value of 12. For
//    *            a leap year, 13 will be the expected value for Adar II. Use the constants {@link JewishDate#NISSAN}
//    *            etc.
//    * @param dayOfMonth
//    *            the Jewish day of month. valid values are 1-30. If the day of month is set to 30 for a month that only
//    *            has 29 days, the day will be set as 29.
//    * @return the absolute date of the Jewish date.
//    */
//    private static int jewishDateToAbsDate(int year, int month, int dayOfMonth) {
//        int elapsed = getDaysSinceStartOfJewishYear(year, month, dayOfMonth);
//        // add elapsed days this year + Days in prior years + Days elapsed before absolute year 1
//        return elapsed + getJewishCalendarElapsedDays(year) + JEWISH_EPOCH;
//    }
//
//    /**
//    * Returns the molad for a given year and month. Returns a JewishDate {@link Object} set to the date of the molad
//    * with the {@link #getMoladHours() hours}, {@link #getMoladMinutes() minutes} and {@link #getMoladChalakim()
//    * chalakim} set. In the current implementation, it sets the molad time based on a midnight date rollover. This
//    * means that Rosh Chodesh Adar II, 5771 with a molad of 7 chalakim past midnight on Shabbos 29 Adar I / March 5,
//    * 2011 12:00 AM and 7 chalakim, will have the following values: hours: 0, minutes: 0, Chalakim: 7.
//    *
//    * @return a JewishDate {@link Object} set to the date of the molad with the {@link #getMoladHours() hours},
//    *         {@link #getMoladMinutes() minutes} and {@link #getMoladChalakim() chalakim} set.
//    */
//    public JewishDate getMolad() {
//        JewishDate moladDate = new JewishDate(getChalakimSinceMoladTohu());
//        if (moladDate.getMoladHours() >= 6) {
//            moladDate.forward();
//        }
//        moladDate.setMoladHours((moladDate.getMoladHours() + 18) % 24);
//        return moladDate;
//    }
//
//    /**
//    * Returns the number of days from the Jewish epoch from the number of chalakim from the epoch passed in.
//    *
//    * @param chalakim
//    *            the number of chalakim since the beginning of Sunday prior to BaHaRaD
//    * @return the number of days from the Jewish epoch
//    */
//    private static int moladToAbsDate(long chalakim) {
//        return (int) (chalakim / CHALAKIM_PER_DAY) + JEWISH_EPOCH;
//    }
//
//    /**
//    * Constructor that creates a JewishDate based on a molad passed in. The molad would be the number of chalakim/parts
//    * starting at the begining of Sunday prior to the molad Tohu BeHaRaD (Be = Monday, Ha= 5 hours and Rad =204
//    * chalakim/parts) - prior to the start of the Jewish calendar. BeHaRaD is 23:11:20 on Sunday night(5 hours 204/1080
//    * chalakim after sunset on Sunday evening).
//    *
//    * @param molad
//    */
//    public JewishDate(long molad) {
//        absDateToDate(moladToAbsDate(molad));
//        // long chalakimSince = getChalakimSinceMoladTohu(year, JewishDate.TISHREI);// tishrei
//        int conjunctionDay = (int) (molad / (long) CHALAKIM_PER_DAY);
//        int conjunctionParts = (int) (molad - conjunctionDay * (long) CHALAKIM_PER_DAY);
//        setMoladTime(conjunctionParts);
//    }
//
//    /**
//    * Sets the molad time (hours minutes and chalakim) based on the number of chalakim since the start of the day.
//    *
//    * @param chalakim
//    *            the number of chalakim since the start of the day.
//    */
//    private void setMoladTime(int chalakim) {
//        int adjustedChalakim = chalakim;
//        setMoladHours(adjustedChalakim / CHALAKIM_PER_HOUR);
//        adjustedChalakim = adjustedChalakim - (getMoladHours() * CHALAKIM_PER_HOUR);
//        setMoladMinutes(adjustedChalakim / CHALAKIM_PER_MINUTE);
//        setMoladChalakim(adjustedChalakim - moladMinutes * CHALAKIM_PER_MINUTE);
//    }
//
//    /**
//    * returns the number of days from Rosh Hashana of the date passed in, till the full date passed in.
//    *
//    * @param year
//    *            the Jewish year
//    * @param month
//    *            the Jewish month
//    * @param dayOfMonth
//    *            the day in the Jewish month
//    * @return the number of days
//    */
//    private static int getDaysSinceStartOfJewishYear(int year, int month, int dayOfMonth) {
//        int elapsedDays = dayOfMonth;
//        // Before Tishrei (from Nissan to Tishrei), add days in prior months
//        if (month < TISHREI) {
//            // this year before and after Nisan.
//            for (int m = TISHREI; m <= getLastMonthOfJewishYear(year); m++) {
//                elapsedDays += getDaysInJewishMonth(m, year);
//            }
//            for (int m = NISSAN; m < month; m++) {
//                elapsedDays += getDaysInJewishMonth(m, year);
//            }
//        } else { // Add days in prior months this year
//            for (int m = TISHREI; m < month; m++) {
//                elapsedDays += getDaysInJewishMonth(m, year);
//            }
//        }
//        return elapsedDays;
//    }
//
