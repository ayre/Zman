//
//  ZMGregorianDate.swift
//  AYZman
//
//  Created by Andrés Catalán on 2016–01–12.
//  Copyright © 2016 Ayre. All rights reserved.
//

import Foundation

struct ZMGregorianDate {
    var day: Int
    var month: Int
    var year: Int
    var absoluteDate: Int
    
    // See: absDateToDate(int absDate)
    init(fromAbsoluteDate absoluteDate: Int) {
        self.absoluteDate = absoluteDate
        self.year = absoluteDate / 366
        while absoluteDate >= ZMGregorianDate.toAbsoluteDate(year: year + 1, month: 1, day: 1) {
            self.year += 1
        }
        self.month = 1
        while absoluteDate > ZMGregorianDate.toAbsoluteDate(year: self.year, month: self.month, day: ZMGregorianDate.lastDayOfMonth(self.month, year: self.year)) {
            self.month += 1
        }
        self.day = absoluteDate - ZMGregorianDate.toAbsoluteDate(year: self.year, month: self.month, day: 1) + 1
    }
    
    // See: getLastDayOfGregorianMonth(int month, int year)
    static func lastDayOfMonth(month: Int, year: Int) -> Int {
        switch month {
        case 2:
            if (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0) {
                return 29
            } else {
                return 28
            }
        case 4, 6, 9, 11:
            return 30
        default:
            return 31
        }
    }

    // See: getLastDayOfGregorianMonth(int month)
    func lastDayOfMonth(month: Int) -> Int {
        return ZMGregorianDate.lastDayOfMonth(month, year: self.year)
    }

    // See: gregorianDateToAbsDate(int year, int month, int dayOfMonth)
    static func toAbsoluteDate(year year: Int, month: Int, day: Int) -> Int {
        var absoluteDate: Int = day
        if month > 1 {
            for m in 1...(month - 1) {
                absoluteDate += lastDayOfMonth(m, year: year)
            }
        }
        return (absoluteDate + 365 * (year - 1) + (year - 1) / 4 - (year - 1) / 100 + (year - 1) / 400)
    }
    
    
}

//    /**
//    * Validates the components of a Jewish date for validity. It will throw an {@link IllegalArgumentException} if the
//    * Jewish date is earlier than 18 Teves, 3761 (1/1/1 Gregorian), a month < 1 or > 12 (or 13 on a
//    * {@link #isJewishLeapYear(int) leap year}), the day of month is < 1 or > 30, an hour < 0 or > 23, a minute < 0 >
//    * 59 or chalakim < 0 > 17. For larger a larger number of chalakim such as 793 (TaShTzaG) break the chalakim into
//    * minutes (18 chalakim per minutes, so it would be 44 minutes and 1 chelek in the case of 793/TaShTzaG).
//    *
//    * @param year
//    *            the Jewish year to validate. It will reject any year <= 3761 (lower than the year 1 Gregorian).
//    * @param month
//    *            the Jewish month to validate. It will reject a month < 1 or > 12 (or 13 on a leap year) .
//    * @param dayOfMonth
//    *            the day of the Jewish month to validate. It will reject any value < 1 or > 30 TODO: check calling
//    *            methods to see if there is any reason that the class can validate that 30 is invalid for some months.
//    * @param hours
//    *            the hours (for molad calculations). It will reject an hour < 0 or > 23
//    * @param minutes
//    *            the minutes (for molad calculations). It will reject a minute < 0 or > 59
//    * @param chalakim
//    *            the chalakim/parts (for molad calculations). It will reject a chalakim < 0 or > 17. For larger numbers
//    *            such as 793 (TaShTzaG) break the chalakim into minutes (18 chalakim per minutes, so it would be 44
//    *            minutes and 1 chelek in the case of 793/TaShTzaG)
//    *
//    * @throws IllegalArgumentException
//    *             if a A Jewish date earlier than 18 Teves, 3761 (1/1/1 Gregorian), a month < 1 or > 12 (or 13 on a
//    *             leap year), the day of month is < 1 or > 30, an hour < 0 or > 23, a minute < 0 > 59 or chalakim < 0 >
//    *             17. For larger a larger number of chalakim such as 793 (TaShTzaG) break the chalakim into minutes (18
//    *             chalakim per minutes, so it would be 44 minutes and 1 chelek in the case of 793 (TaShTzaG).
//    */
//    private static void validateJewishDate(int year, int month, int dayOfMonth, int hours, int minutes, int chalakim) {
//        if (month < NISSAN || month > getLastMonthOfJewishYear(year)) {
//            throw new IllegalArgumentException("The Jewish month has to be between 1 and 12 (or 13 on a leap year). "
//                + month + " is invalid for the year " + year + ".");
//        }
//        if (dayOfMonth < 1 || dayOfMonth > 30) {
//            throw new IllegalArgumentException("The Jewish day of month can't be < 1 or > 30.  " + dayOfMonth
//                + " is invalid.");
//        }
//        // reject dates prior to 18 Teves, 3761 (1/1/1 AD). This restriction can be relaxed if the date coding is
//        // changed/corrected
//        if ((year < 3761) || (year == 3761 && (month >= TISHREI && month < TEVES))
//            || (year == 3761 && month == TEVES && dayOfMonth < 18)) {
//                throw new IllegalArgumentException(
//                    "A Jewish date earlier than 18 Teves, 3761 (1/1/1 Gregorian) can't be set. " + year + ", " + month
//                        + ", " + dayOfMonth + " is invalid.");
//        }
//        if (hours < 0 || hours > 23) {
//            throw new IllegalArgumentException("Hours < 0 > 23 can't be set. " + hours + " is invalid.");
//        }
//        
//        if (minutes < 0 || minutes > 59) {
//            throw new IllegalArgumentException("Minutes < 0 > 59 can't be set. " + minutes + " is invalid.");
//        }
//        
//        if (chalakim < 0 || chalakim > 17) {
//            throw new IllegalArgumentException(
//                "Chalakim/parts < 0 > 17 can't be set. "
//                    + chalakim
//                    + " is invalid. For larger numbers such as 793 (TaShTzaG) break the chalakim into minutes (18 chalakim per minutes, so it would be 44 minutes and 1 chelek in the case of 793 (TaShTzaG)");
//        }
//    }
//    
//    /**
//    * Validates the components of a Gregorian date for validity. It will throw an {@link IllegalArgumentException} if a
//    * year of < 1, a month < 0 or > 11 or a day of month < 1 is passed in.
//    *
//    * @param year
//    *            the Gregorian year to validate. It will reject any year < 1.
//    * @param month
//    *            the Gregorian month number to validate. It will enforce that the month is between 0 - 11 like a
//    *            {@link GregorianCalendar}, where {@link Calendar#JANUARY} has a value of 0.
//    * @param dayOfMonth
//    *            the day of the Gregorian month to validate. It will reject any value < 1, but will allow values > 31
//    *            since calling methods will simply set it to the maximum for that month. TODO: check calling methods to
//    *            see if there is any reason that the class needs days > the maximum.
//    * @throws IllegalArgumentException
//    *             if a year of < 1, a month < 0 or > 11 or a day of month < 1 is passed in
//    * @see #validateGregorianYear(int)
//    * @see #validateGregorianMonth(int)
//    * @see #validateGregorianDayOfMonth(int)
//    */
//    private static void validateGregorianDate(int year, int month, int dayOfMonth) {
//        validateGregorianMonth(month);
//        validateGregorianDayOfMonth(dayOfMonth);
//        validateGregorianYear(year);
//    }
//    
//    /**
//    * Validates a Gregorian month for validity.
//    *
//    * @param month
//    *            the Gregorian month number to validate. It will enforce that the month is between 0 - 11 like a
//    *            {@link GregorianCalendar}, where {@link Calendar#JANUARY} has a value of 0.
//    */
//    private static void validateGregorianMonth(int month) {
//        if (month > 11 || month < 0) {
//            throw new IllegalArgumentException("The Gregorian month has to be between 0 - 11. " + month
//                + " is invalid.");
//        }
//    }
//    
//    /**
//    * Validates a Gregorian day of month for validity.
//    *
//    * @param dayOfMonth
//    *            the day of the Gregorian month to validate. It will reject any value < 1, but will allow values > 31
//    *            since calling methods will simply set it to the maximum for that month. TODO: check calling methods to
//    *            see if there is any reason that the class needs days > the maximum.
//    */
//    private static void validateGregorianDayOfMonth(int dayOfMonth) {
//        if (dayOfMonth <= 0) {
//            throw new IllegalArgumentException("The day of month can't be less than 1. " + dayOfMonth + " is invalid.");
//        }
//    }
//    
//    /**
//    * Validates a Gregorian year for validity.
//    *
//    * @param year
//    *            the Gregorian year to validate. It will reject any year < 1.
//    */
//    private static void validateGregorianYear(int year) {
//        if (year < 1) {
//            throw new IllegalArgumentException("Years < 1 can't be claculated. " + year + " is invalid.");
//        }
//    }
//    





//    /**
//    * Creates a Jewish date based on a Jewish year, month and day of month.
//    *
//    * @param jewishYear
//    *            the Jewish year
//    * @param jewishMonth
//    *            the Jewish month. The method expects a 1 for Nissan ... 12 for Adar and 13 for Adar II. Use the
//    *            constants {@link #NISSAN} ... {@link #ADAR} (or {@link #ADAR_II} for a leap year Adar II) to avoid any
//    *            confusion.
//    * @param jewishDayOfMonth
//    *            the Jewish day of month. If 30 is passed in for a month with only 29 days (for example {@link #IYAR},
//    *            or {@link #KISLEV} in a year that {@link #isKislevShort()}), the 29th (last valid date of the month)
//    *            will be set
//    * @throws IllegalArgumentException
//    *             if the day of month is < 1 or > 30, or a year of < 0 is passed in.
//    */
//    public JewishDate(int jewishYear, int jewishMonth, int jewishDayOfMonth) {
//        setJewishDate(jewishYear, jewishMonth, jewishDayOfMonth);
//    }
//    
//    /**
//    * Default constructor will set a default date to the current system date.
//    */
//    public JewishDate() {
//        resetDate();
//    }
//    
//    /**
//    * A constructor that initializes the date to the {@link java.util.Date Date} paremeter.
//    *
//    * @param date
//    *            the <code>Date</code> to set the calendar to
//    * @throws IllegalArgumentException
//    *             if the date would fall prior to the January 1, 1 AD
//    */
//    public JewishDate(Date date) {
//        setDate(date);
//    }
//    
//    /**
//    * A constructor that initializes the date to the {@link java.util.Calendar Calendar} paremeter.
//    *
//    * @param calendar
//    *            the <code>Calendar</code> to set the calendar to
//    * @throws IllegalArgumentException
//    *             if the {@link Calendar#ERA} is {@link GregorianCalendar#BC}
//    */
//    public JewishDate(Calendar calendar) {
//        setDate(calendar);
//    }
//    
//    /**
//    * Sets the date based on a {@link java.util.Calendar Calendar} object. Modifies the Jewish date as well.
//    *
//    * @param calendar
//    *            the <code>Calendar</code> to set the calendar to
//    * @throws IllegalArgumentException
//    *             if the {@link Calendar#ERA} is {@link GregorianCalendar#BC}
//    */
//    public void setDate(Calendar calendar) {
//        if (calendar.get(Calendar.ERA) == GregorianCalendar.BC) {
//            throw new IllegalArgumentException("Calendars with a BC era are not supported. The year "
//                + calendar.get(Calendar.YEAR) + " BC is invalid.");
//        }
//        gregorianMonth = calendar.get(Calendar.MONTH) + 1;
//        gregorianDayOfMonth = calendar.get(Calendar.DATE);
//        gregorianYear = calendar.get(Calendar.YEAR);
//        gregorianAbsDate = gregorianDateToAbsDate(gregorianYear, gregorianMonth, gregorianDayOfMonth); // init the date
//        absDateToJewishDate();
//        
//        dayOfWeek = Math.abs(gregorianAbsDate % 7) + 1; // set day of week
//    }
//    
//    /**
//    * Sets the date based on a {@link java.util.Date Date} object. Modifies the Jewish date as well.
//    *
//    * @param date
//    *            the <code>Date</code> to set the calendar to
//    * @throws IllegalArgumentException
//    *             if the date would fall prior to the year 1 AD
//    */
//    public void setDate(Date date) {
//        Calendar cal = Calendar.getInstance();
//        cal.setTime(date);
//        setDate(cal);
//    }
//    
//    /**
//    * Sets the Gregorian Date, and updates the Jewish date accordingly. Like the Java Calendar A value of 0 is expected
//    * for January.
//    *
//    * @param year
//    *            the Gregorian year
//    * @param month
//    *            the Gregorian month. Like the Java Calendar, this class expects 0 for January
//    * @param dayOfMonth
//    *            the Gregorian day of month. If this is > the number of days in the month/year, the last valid date of
//    *            the month will be set
//    * @throws IllegalArgumentException
//    *             if a year of < 1, a month < 0 or > 11 or a day of month < 1 is passed in
//    */
//    public void setGregorianDate(int year, int month, int dayOfMonth) {
//        validateGregorianDate(year, month, dayOfMonth);
//        setInternalGregorianDate(year, month + 1, dayOfMonth);
//    }
//    
//    /**
//    * Sets the hidden internal representation of the Gregorian date , and updates the Jewish date accordingly. While
//    * public getters and setters have 0 based months matching the Java Calendar classes, This class internally
//    * represents the Gregorian month starting at 1. When this is called it will not adjust the month to match the Java
//    * Calendar classes.
//    *
//    * @param year
//    *            the
//    * @param month
//    * @param dayOfMonth
//    */
//    private void setInternalGregorianDate(int year, int month, int dayOfMonth) {
//        // make sure date is a valid date for the given month, if not, set to last day of month
//        if (dayOfMonth > getLastDayOfGregorianMonth(month, year)) {
//            dayOfMonth = getLastDayOfGregorianMonth(month, year);
//        }
//        // init month, date, year
//        gregorianMonth = month;
//        gregorianDayOfMonth = dayOfMonth;
//        gregorianYear = year;
//        
//        gregorianAbsDate = gregorianDateToAbsDate(gregorianYear, gregorianMonth, gregorianDayOfMonth); // init date
//        absDateToJewishDate();
//        
//        dayOfWeek = Math.abs(gregorianAbsDate % 7) + 1; // set day of week
//    }
//    
//    /**
//    * Sets the Jewish Date and updates the Gregorian date accordingly.
//    *
//    * @param year
//    *            the Jewish year. The year can't be negative
//    * @param month
//    *            the Jewish month starting with Nisan. A value of 1 is expected for Nissan ... 12 for Adar and 13 for
//    *            Adar II. Use the constants {@link #NISSAN} ... {@link #ADAR} (or {@link #ADAR_II} for a leap year Adar
//    *            II) to avoid any confusion.
//    * @param dayOfMonth
//    *            the Jewish day of month. valid values are 1-30. If the day of month is set to 30 for a month that only
//    *            has 29 days, the day will be set as 29.
//    * @throws IllegalArgumentException
//    *             if a A Jewish date earlier than 18 Teves, 3761 (1/1/1 Gregorian), a month < 1 or > 12 (or 13 on a
//    *             leap year) or the day of month is < 1 or > 30 is passed in
//    */
//    public void setJewishDate(int year, int month, int dayOfMonth) {
//        setJewishDate(year, month, dayOfMonth, 0, 0, 0);
//    }
//    
//    /**
//    * Sets the Jewish Date and updates the Gregorian date accordingly.
//    *
//    * @param year
//    *            the Jewish year. The year can't be negative
//    * @param month
//    *            the Jewish month starting with Nisan. A value of 1 is expected for Nissan ... 12 for Adar and 13 for
//    *            Adar II. Use the constants {@link #NISSAN} ... {@link #ADAR} (or {@link #ADAR_II} for a leap year Adar
//    *            II) to avoid any confusion.
//    * @param dayOfMonth
//    *            the Jewish day of month. valid values are 1-30. If the day of month is set to 30 for a month that only
//    *            has 29 days, the day will be set as 29.
//    *
//    * @param hours
//    *            the hour of the day. Used for Molad calculations
//    * @param minutes
//    *            the minutes. Used for Molad calculations
//    * @param chalakim
//    *            the chalakim/parts. Used for Molad calculations. The chalakim should not exceed 17. Minutes should be
//    *            used for larger numbers.
//    *
//    * @throws IllegalArgumentException
//    *             if a A Jewish date earlier than 18 Teves, 3761 (1/1/1 Gregorian), a month < 1 or > 12 (or 13 on a
//    *             leap year), the day of month is < 1 or > 30, an hour < 0 or > 23, a minute < 0 > 59 or chalakim < 0 >
//    *             17. For larger a larger number of chalakim such as 793 (TaShTzaG) break the chalakim into minutes (18
//    *             chalakim per minutes, so it would be 44 minutes and 1 chelek in the case of 793 (TaShTzaG).
//    */
//    public void setJewishDate(int year, int month, int dayOfMonth, int hours, int minutes, int chalakim) {
//        validateJewishDate(year, month, dayOfMonth, hours, minutes, chalakim);
//        
//        // if 30 is passed for a month that only has 29 days (for example by rolling the month from a month that had 30
//        // days to a month that only has 29) set the date to 29th
//        if (dayOfMonth > getDaysInJewishMonth(month, year)) {
//            dayOfMonth = getDaysInJewishMonth(month, year);
//        }
//        
//        jewishMonth = month;
//        jewishDay = dayOfMonth;
//        jewishYear = year;
//        moladHours = hours;
//        moladMinutes = minutes;
//        moladChalakim = chalakim;
//        
//        gregorianAbsDate = jewishDateToAbsDate(jewishYear, jewishMonth, jewishDay); // reset Gregorian date
//        absDateToDate(gregorianAbsDate);
//        
//        dayOfWeek = Math.abs(gregorianAbsDate % 7) + 1; // reset day of week
//    }
//    
//    /**
//    * Returns this object's date as a java.util.Date object. <b>Note</b>: This class does not have a concept of time.
//    *
//    * @return The <code>Date</code>
//    */
//    public Date getTime() {
//        Calendar cal = Calendar.getInstance();
//        cal.set(gregorianYear, gregorianMonth - 1, gregorianDayOfMonth);
//        return cal.getTime();
//    }
//    
//    /**
//    * Resets this date to the current system date.
//    */
//    public void resetDate() {
//        Calendar calendar = Calendar.getInstance();
//        setDate(calendar);
//    }
//    
//    /**
//    * Returns a string containing the Jewish date in the form, "day Month, year" e.g. "21 Shevat, 5729". For more
//    * complex formatting, use the formatter classes.
//    *
//    * @return the Jewish date in the form "day Month, year" e.g. "21 Shevat, 5729"
//    * @see HebrewDateFormatter#format(JewishDate)
//    */
//    public String toString() {
//        return new HebrewDateFormatter().format(this);
//    }
//    
//    /**
//    * Rolls the date forward by 1 day. It modifies both the Gregorian and Jewish dates accordingly. The API does not
//    * currently offer the ability to forward more than one day t a time, or to forward by month or year. If such
//    * manipulation is required use the {@link Calendar} class {@link Calendar#add(int, int)} or
//    * {@link Calendar#roll(int, int)} methods in the following manner.
//    *
//    * <pre>
//    * <code>
//    * 	Calendar cal = jewishDate.getTime(); // get a java.util.Calendar representation of the JewishDate
//    * 	cal.add(Calendar.MONTH, 3); // add 3 Gregorian months
//    * 	jewishDate.setDate(cal); // set the updated calendar back to this class
//    * </code>
//    * </pre>
//    *
//    * @see #back()
//    * @see Calendar#add(int, int)
//    * @see Calendar#roll(int, int)
//    */
//    public void forward() {
//        // Change Gregorian date
//        if (gregorianDayOfMonth == getLastDayOfGregorianMonth(gregorianMonth, gregorianYear)) {
//            // if last day of year
//            if (gregorianMonth == 12) {
//                gregorianYear++;
//                gregorianMonth = 1;
//                gregorianDayOfMonth = 1;
//            } else {
//                gregorianMonth++;
//                gregorianDayOfMonth = 1;
//            }
//        } else { // if not last day of month
//            gregorianDayOfMonth++;
//        }
//        
//        // Change the Jewish Date
//        if (jewishDay == getDaysInJewishMonth()) {
//            // if it last day of elul (i.e. last day of Jewish year)
//            if (jewishMonth == ELUL) {
//                jewishYear++;
//                jewishMonth++;
//                jewishDay = 1;
//            } else if (jewishMonth == getLastMonthOfJewishYear(jewishYear)) {
//                // if it is the last day of Adar, or Adar II as case may be
//                jewishMonth = NISSAN;
//                jewishDay = 1;
//            } else {
//                jewishMonth++;
//                jewishDay = 1;
//            }
//        } else { // if not last date of month
//            jewishDay++;
//        }
//        
//        if (dayOfWeek == 7) { // if last day of week, loop back to Sunday
//            dayOfWeek = 1;
//        } else {
//            dayOfWeek++;
//        }
//        
//        gregorianAbsDate++; // increment the absolute date
//    }
//    
//    /**
//    * Rolls the date back by 1 day. It modifies both the Gregorian and Jewish dates accordingly. The API does not
//    * currently offer the ability to forward more than one day t a time, or to forward by month or year. If such
//    * manipulation is required use the {@link Calendar} class {@link Calendar#add(int, int)} or
//    * {@link Calendar#roll(int, int)} methods in the following manner.
//    *
//    * <pre>
//    * <code>
//    * 	Calendar cal = jewishDate.getTime(); // get a java.util.Calendar representation of the JewishDate
//    * 	cal.add(Calendar.MONTH, -3); // subtract 3 Gregorian months
//    * 	jewishDate.setDate(cal); // set the updated calendar back to this class
//    * </code>
//    * </pre>
//    *
//    * @see #back()
//    * @see Calendar#add(int, int)
//    * @see Calendar#roll(int, int)
//    */
//    public void back() {
//        // Change Gregorian date
//        if (gregorianDayOfMonth == 1) { // if first day of month
//            if (gregorianMonth == 1) { // if first day of year
//                gregorianMonth = 12;
//                gregorianYear--;
//            } else {
//                gregorianMonth--;
//            }
//            // change to last day of previous month
//            gregorianDayOfMonth = getLastDayOfGregorianMonth(gregorianMonth, gregorianYear);
//        } else {
//            gregorianDayOfMonth--;
//        }
//        // change Jewish date
//        if (jewishDay == 1) { // if first day of the Jewish month
//            if (jewishMonth == NISSAN) {
//                jewishMonth = getLastMonthOfJewishYear(jewishYear);
//            } else if (jewishMonth == TISHREI) { // if Rosh Hashana
//                jewishYear--;
//                jewishMonth--;
//            } else {
//                jewishMonth--;
//            }
//            jewishDay = getDaysInJewishMonth();
//        } else {
//            jewishDay--;
//        }
//        
//        if (dayOfWeek == 1) { // if first day of week, loop back to Saturday
//            dayOfWeek = 7;
//        } else {
//            dayOfWeek--;
//        }
//        gregorianAbsDate--; // change the absolute date
//    }
//    
//    /**
//    * @see Object#equals(Object)
//    */
//    public boolean equals(Object object) {
//        if (this == object) {
//            return true;
//        }
//        if (!(object instanceof JewishDate)) {
//            return false;
//        }
//        JewishDate jewishDate = (JewishDate) object;
//        return gregorianAbsDate == jewishDate.getAbsDate();
//    }
//    
//    /**
//    * Compares two dates as per the compareTo() method in the Comparable interface. Returns a value less than 0 if this
//    * date is "less than" (before) the date, greater than 0 if this date is "greater than" (after) the date, or 0 if
//    * they are equal.
//    */
//    public int compareTo(JewishDate jewishDate) {
//        return gregorianAbsDate < jewishDate.getAbsDate() ? -1 : gregorianAbsDate > jewishDate.getAbsDate() ? 1 : 0;
//    }
//    
//    /**
//    * Returns the Gregorian month (between 0-11).
//    * 
//    * @return the Gregorian month (between 0-11). Like the java.util.Calendar, months are 0 based.
//    */
//    public int getGregorianMonth() {
//        return gregorianMonth - 1;
//    }
//    
//    /**
//    * Returns the Gregorian day of the month.
//    * 
//    * @return the Gregorian day of the mont
//    */
//    public int getGregorianDayOfMonth() {
//        return gregorianDayOfMonth;
//    }
//    
//    /**
//    * Returns the Gregotian year.
//    * 
//    * @return the Gregorian year
//    */
//    public int getGregorianYear() {
//        return gregorianYear;
//    }
//    
//    /**
//    * Returns the Jewish month 1-12 (or 13 years in a leap year). The month count starts with 1 for Nisan and goes to
//    * 13 for Adar II
//    * 
//    * @return the Jewish month from 1 to 12 (or 13 years in a leap year). The month count starts with 1 for Nisan and
//    *         goes to 13 for Adar II
//    */
//    public int getJewishMonth() {
//        return jewishMonth;
//    }
//    
//    /**
//    * Returns the Jewish day of month.
//    * 
//    * @return the Jewish day of the month
//    */
//    public int getJewishDayOfMonth() {
//        return jewishDay;
//    }
//    
//    /**
//    * Returns the Jewish year.
//    * 
//    * @return the Jewish year
//    */
//    public int getJewishYear() {
//        return jewishYear;
//    }
//    
//    /**
//    * Returns the day of the week as a number between 1-7.
//    * 
//    * @return the day of the week as a number between 1-7.
//    */
//    public int getDayOfWeek() {
//        return dayOfWeek;
//    }
//    
//    /**
//    * Sets the Gregorian month.
//    * 
//    * @param month
//    *            the Gregorian month
//    * 
//    * @throws IllegalArgumentException
//    *             if a month < 0 or > 11 is passed in
//    */
//    public void setGregorianMonth(int month) {
//        validateGregorianMonth(month);
//        setInternalGregorianDate(gregorianYear, month + 1, gregorianDayOfMonth);
//    }
//    
//    /**
//    * sets the Gregorian year.
//    * 
//    * @param year
//    *            the Gregorian year.
//    * @throws IllegalArgumentException
//    *             if a year of < 1 is passed in
//    */
//    public void setGregorianYear(int year) {
//        validateGregorianYear(year);
//        setInternalGregorianDate(year, gregorianMonth, gregorianDayOfMonth);
//    }
//    
//    /**
//    * sets the Gregorian Day of month.
//    * 
//    * @param dayOfMonth
//    *            the Gregorian Day of month.
//    * @throws IllegalArgumentException
//    *             if the day of month of < 1 is passed in
//    */
//    public void setGregorianDayOfMonth(int dayOfMonth) {
//        validateGregorianDayOfMonth(dayOfMonth);
//        setInternalGregorianDate(gregorianYear, gregorianMonth, dayOfMonth);
//    }
//    
//    /**
//    * sets the Jewish month.
//    * 
//    * @param month
//    *            the Jewish month from 1 to 12 (or 13 years in a leap year). The month count starts with 1 for Nisan
//    *            and goes to 13 for Adar II
//    * @throws IllegalArgumentException
//    *             if a month < 1 or > 12 (or 13 on a leap year) is passed in
//    */
//    public void setJewishMonth(int month) {
//        setJewishDate(jewishYear, month, jewishDay);
//    }
//    
//    /**
//    * sets the Jewish year.
//    * 
//    * @param year
//    *            the Jewish year
//    * @throws IllegalArgumentException
//    *             if a year of < 3761 is passed in. The same will happen if the year is 3761 and the month and day
//    *             previously set are < 18 Teves (preior to Jan 1, 1 AD)
//    */
//    public void setJewishYear(int year) {
//        setJewishDate(year, jewishMonth, jewishDay);
//    }
//    
//    /**
//    * sets the Jewish day of month.
//    * 
//    * @param dayOfMonth
//    *            the Jewish day of month
//    * @throws IllegalArgumentException
//    *             if the day of month is < 1 or > 30 is passed in
//    */
//    public void setJewishDayOfMonth(int dayOfMonth) {
//        setJewishDate(jewishYear, jewishMonth, dayOfMonth);
//    }
//    
//    /**
//    * A method that creates a <a href="http://en.wikipedia.org/wiki/Object_copy#Deep_copy">deep copy</a> of the object. <br />
//    * 
//    * @see Object#clone()
//    * @since 1.1
//    */
//    public Object clone() {
//        JewishDate clone = null;
//        try {
//            clone = (JewishDate) super.clone();
//        } catch (CloneNotSupportedException cnse) {
//            // Required by the compiler. Should never be reached since we implement clone()
//        }
//        clone.setInternalGregorianDate(gregorianYear, gregorianMonth, gregorianDayOfMonth);
//        return clone;
//    }
//    
//    /**
//    * @see Object#hashCode()
//    */
//    public int hashCode() {
//        int result = 17;
//        result = 37 * result + getClass().hashCode(); // needed or this and subclasses will return identical hash
//        result += 37 * result + gregorianAbsDate;
//        return result;
//    }
//}
