//
//  ViewController.swift
//  RNDateHelper
//
//  Created by 罗伟 on 2017/2/20.
//  Copyright © 2017年 罗伟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.dateToComponents()
        //self.componentsToDate()
        //self.addDate()
        self.getDateInterval()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DateComponents
    
    
    func dateToComponents() {
        let calendar = Calendar.current
        
        //通过 calendar 对象初始化 dateComponents
        /// - parameter component: 你需要的组件信息(如年份，月份，星期等)详见 Calendar内部的Component枚举
        /// - parameter date: 你想转换的日期.
        /// - returns: 转换后的 component.

        let dateComponents = calendar.dateComponents([Calendar.Component.day, Calendar.Component.weekday], from: Date())
        let weekDay = Weekday(rawValue: dateComponents.weekday!)
        
        if let weekDayStr = weekDay?.string(), let day = dateComponents.day {
           print("今天是\(day)号 \(weekDayStr)")
        }
    }
    
    func componentsToDate() {
        var components = DateComponents()
        components.day = 21
        components.month = 01
        components.year = 2017
        components.hour = 14
        components.minute = 30
        
        //设置时区 "CST":中国标准时间 "GMT"格林标准时间 详见( https://www.timeanddate.com/time/zones/)
       
        //components.timeZone = TimeZone(abbreviation: "CST")
        
        let date = Calendar.current.date(from: components)
        
        if let date = date {
            print("转换后的日期\(date)")
        }
    }
    
    func compareDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let firstDateStr = "2017-02-20"
        let secondDateStr = "2017-02-25"
        let firstDate = dateFormatter.date(from: firstDateStr)
        let secondDate = dateFormatter.date(from: secondDateStr)
        
        //第一种方法
        let results = firstDate?.compare(secondDate!)
        
        switch results! {
        case ComparisonResult.orderedAscending:
            print("firstDate 早于 secondDate")
            
        case ComparisonResult.orderedDescending:
            print("firstDate 晚于 secondDate")
            
        case ComparisonResult.orderedSame:
            print("时间相同")
        }
        
        //第二种方法
        if firstDate?.timeIntervalSinceReferenceDate == secondDate?.timeIntervalSinceReferenceDate {
            print("时间相同")
        } else if firstDate!.timeIntervalSinceReferenceDate > secondDate!.timeIntervalSinceReferenceDate {
            print("firstDate 晚于 secondDate")
        } else {
           print("firstDate 早于 secondDate")
        }
    }
    
    func addDate() {
        let date = Date()//当前时间
        
        //第一种：使用 Calendar
        //获取当前时间1天后的日期 value为负数时代表过去的时间
        let tomorrowDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: date)
        print(tomorrowDate!)
        
        //获取当前时间1个月后的的日期
        let nextMonthDate = Calendar.current.date(byAdding: Calendar.Component.month, value: 1, to: date)
        print(nextMonthDate!)
        
//        var newDate = Calendar.current.date(byAdding: Calendar.Component.month, value: 1, to: date)
//        newDate = Calendar.current.date(byAdding: Calendar.Component.month, value: 1, to: newDate!)
//        print(newDate!)
        
        //第二种：使用 DateComponents + Calendar
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.month = 1
        
        let newDate = NSCalendar.current.date(byAdding: dateComponents, to: date)
        
        print(newDate!)
    }
    
    func getDateInterval() {
        // 第一种：使用 DateComponents + Calendar
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let firstDateStr = "2017-02-20"
        let secondDateStr = "2017-02-25"
        let firstDate = dateFormatter.date(from: firstDateStr)
        let secondDate = dateFormatter.date(from: secondDateStr)
        
        let dateComponents = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month], from: firstDate!, to: secondDate!)
        print(dateComponents.day!)
        print(dateComponents.month!)
        
        
        // 第二种(比较low)
//        let timeInterval = (secondDate?.timeIntervalSince1970)! - (firstDate?.timeIntervalSince1970)!
//        print(timeInterval/(3600*24))
        
        
        //第三种： DateComponentsFormatter
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = .full
        let interval = secondDate?.timeIntervalSince(firstDate!)
        let timeInterval = dateComponentsFormatter.string(from: interval!)
        print(timeInterval!)
    
    }
}

