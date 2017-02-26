//
//  RNDateHelper.swift
//  RNDateHelper
//
//  Created by 罗伟 on 2017/2/22.
//  Copyright © 2017年 罗伟. All rights reserved.
//

import UIKit

public enum DatePattern: String {
    //可自行扩充
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
    case MMddHHmm = "MM-dd HH:mm"
    case yyyyMMdd = "yyyy-MM-dd"
    case yyyyMdd = "yyyy-M-dd"
    case yyyyMMdd2 = "yyyy.MM.dd"
    case yyyyMM = "yyyy-MM"
    case HHmmss = "HH:mm:ss"
    case HHmm = "HH:mm"
    case MdChinese = "MM月d日"
    case MMddChinese = "MM月dd日"
    case yyyyMddhhmmss = "yyyy/M/dd hh:mm:ss"
    case yyyyMMddHHmmChinese = "yyyy年MM月dd日 HH:mm"
    case yyyyMMddChinese = "yyyy年MM月dd日"
    case yyyyMMChinese = "yyyy年MM月"
    case MMddHHmmChinese = "MM月dd日HH:mm"
}

public enum Weekday: Int {
    case `default` = 0, sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    func string() -> String {
        var title = ""
        
        switch self {
        case .sunday:
            title = "周日"
        case .monday:
            title = "周一"
        case .tuesday:
            title = "周二"
        case .wednesday:
            title = "周三"
        case .thursday:
            title = "周四"
        case .friday:
            title = "周五"
        case .saturday:
            title = "周六"
        case .`default`:
            title = ""
        }
        
        return title
    }
}

extension Date {
    
    /// date -> string
    ///
    /// - Parameters:
    /// - pattern: formatter
    /// - dateFormatter: 该对象都由调用者传入，调用者要维护一个公共的dateFormatter，避免重复 new 影响性能
    /// - Returns: string
    func string(_ pattern: DatePattern, dateFormatter: DateFormatter) -> String {
        dateFormatter.dateFormat = pattern.rawValue
        return dateFormatter.string(from: self)
    }
    
    /// date -> week
    ///
    /// - Parameter date: 要转换的日期
    /// - Returns: 周几对应的数值，详见 Weekday 枚举
    func week() -> Int {
        let dateComponents = Calendar.current.dateComponents([Calendar.Component.weekday], from: self)
        return dateComponents.weekday ?? 0
    }
    
    
    /// date -> weekStr
    ///
    /// - Returns: 周几
    func weekStr() -> String {
        let week = self.week()
        return Weekday(rawValue: week)?.string() ?? ""
    }
    
    /// 判断当前日期是否早于传入的日期
    ///
    /// - parameter date: 要比较的日期
    /// - returns: 当前日期早于传入的日期，返回 true，否则返回 false，相等也返回 false
    func before(then date: Date) -> Bool {
        return self.compare(date) == .orderedAscending
    }
    
    /// 判断当前日期是否晚于传入的日期
    ///
    /// - parameter date: 要比较的日期
    /// - returns: 当前日期晚于传入的日期，返回 true，否则返回 false，相等也返回 false
    func after(then date: Date) -> Bool {
        return self.compare(date) == .orderedDescending
    }
    
    /// 获得新的日期
    ///
    /// - parameter day: 可以为正数和负数，正数为未来的日期，负数为过去的日期
    /// - returns: 新的日期
    func add(day: Int) -> Date {
        var addingDayComponents = DateComponents.init()
        addingDayComponents.day = day
        return Calendar.current.date(byAdding: addingDayComponents, to: self)!
    }
    
    /// 获取某个日期所在当周的第一天
    /// - parameter date:
    /// - parameter firstDayOfWeek: 日历的第一列是周几
    ///
    /// - returns: 第一天
    static func firstDayOfWeekContain(date: Date, firstDayOfWeek: Weekday) -> Date {
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        var firstDateComponents = DateComponents.init()
        firstDateComponents.year = dateComponents.year
        firstDateComponents.weekOfYear = dateComponents.weekOfYear
        firstDateComponents.yearForWeekOfYear = dateComponents.yearForWeekOfYear
        firstDateComponents.weekday = firstDayOfWeek.rawValue
        
        var firstDate = Calendar.current.date(from: firstDateComponents)
        if firstDayOfWeek.rawValue > dateComponents.weekday! {
            // 如果第一列与今天不在同一周，需要特殊处理，取上周的数据
            firstDate = firstDate?.add(day: -7)
        }
        return firstDate!
    }
    
    /// 获取某个日期所在当周的最后一天
    /// - parameter date:
    /// - parameter firstDayOfWeek: 日历的第一列是周几
    ///
    /// - returns: 最后一天
    static func lastDayOfWeekContain(date: Date, firstDayOfWeek: Weekday) -> Date {
        let firstDate = firstDayOfWeekContain(date: date, firstDayOfWeek: firstDayOfWeek)
        return firstDate.add(day: 6)
    }

}

extension String {
    
    /// string -> date
    ///
    /// - parameter pattern: dateFormat格式
    /// - parameter dateFormatter: 该对象都由调用者传入，调用者要维护一个公共的dateFormatter，避免重复 new 影响性能
    ///
    /// - returns: Date
    func date(_ pattern: DatePattern, dateFormatter: DateFormatter) -> Date? {
        dateFormatter.dateFormat = pattern.rawValue
        return dateFormatter.date(from: self)
    }
    
    /// string -(formatter)-> string
    ///
    /// - parameter originalpattern: 原来的dateFormat格式
    /// - parameter newDateStrPattern: 新的dateFormat格式
    /// - parameter dateFormatter: 该对象都由调用者传入，调用者要维护一个公共的dateFormatter，避免重复 new 影响性能
    ///
    /// - returns: 格式转换后的string
    func dateString(_ originalpattern: DatePattern, newDateStrPattern: DatePattern, dateFormatter: DateFormatter) -> String {
        var newDateStr = ""
        if let date = self.date(originalpattern, dateFormatter: dateFormatter) {
            dateFormatter.dateFormat = newDateStrPattern.rawValue
            newDateStr = dateFormatter.string(from: date)
        }
        
        return newDateStr
    }
    
    /// string -(formatter)-> string
    ///
    /// - parameter originalpattern: 原来的dateFormat格式数组（原日期格式有多个格式）
    /// - parameter newDateStrPattern: 新的dateFormat
    /// - parameter dateFormatter: 该对象都由调用者传入，调用者要维护一个公共的dateFormatter，避免重复 new 影响性能
    ///
    /// - returns: 格式转换后的string
    func dateString(_ originalpatterns: [DatePattern], newDateStrPattern: DatePattern, dateFormatter: DateFormatter) -> String {
        var newDateStr = ""
        for originalpattern in originalpatterns {
            if let date = self.date(originalpattern, dateFormatter: dateFormatter) {
                dateFormatter.dateFormat = newDateStrPattern.rawValue
                newDateStr = dateFormatter.string(from: date)
                break
            }
        }
        
        return newDateStr
    }
    
    /// string -> week
    ///
    /// - Parameters:
    /// - pattern: dateFormatter格式
    /// - dateFormatter: 该对象都由调用者传入，调用者要维护一个公共的dateFormatter，避免重复 new 影响性能
    /// - Returns: 周几对应的数值，详见 Weekday 枚举
    func week(_ pattern: DatePattern, dateFormatter: DateFormatter) -> Int {
        let date = self.date(pattern, dateFormatter: dateFormatter)
        return date?.week() ?? 0
    }
    
    /// string -> weekStr
    ///
    /// - Parameters:
    /// - pattern: formatte
    /// - dateFormatter: 该对象都由调用者传入，调用者要维护一个公共的dateFormatter，避免重复 new 影响性能
    /// - Returns: 周几
    func weekStr(with pattern: DatePattern, dateFormatter: DateFormatter) -> String {
        let week = self.week(pattern, dateFormatter: dateFormatter)
        return Weekday(rawValue: week)?.string() ?? ""
    }
    
    /// string -> dateComponents
    ///
    /// - Parameters:
    /// - pattern: formatter
    /// - dateFormatter: 该对象都由调用者传入，调用者要维护一个公共的dateFormatter，避免重复 new 影响性能
    ///   - calendarType: default is gregorian(公历), chinese(农历)详见Calendar.Identifier
    /// - Returns: dateComponents(日期相关信息，包括year,month,day,week)
    func dateComponents(with pattern: DatePattern, dateFormatter: DateFormatter, calendarType: Calendar.Identifier = .gregorian) -> DateComponents {
        let date = self.date(pattern, dateFormatter: dateFormatter)
        let calendar = Calendar(identifier: calendarType)
        let dateComponents = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekday], from: date!)
        print("\(dateComponents.year) \(dateComponents.month) \(dateComponents.day) \(dateComponents.weekday)")
        return dateComponents
    }
     
}
