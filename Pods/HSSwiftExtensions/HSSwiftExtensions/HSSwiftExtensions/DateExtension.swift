//
//  DateExtension.swift
//  SwiftCustomExtensionDemo
//
//  Created by weipo on 2016/10/17.
//  author: huanghaisheng
//  email: haisheng.huang@hotmail.com
//  Copyright © 2016年 weipo. All rights reserved.
//

import Foundation

@available(iOS 8.0, *)

public extension Date {

    //获取当前日期的时间戳(毫秒)
    static func timestampWithCurrentDate() -> TimeInterval {
        return Date().timeIntervalSince1970 * 1000
    }
    
    //获取当前日期的时间戳字符串(毫秒)
    static func timestampStringWithCurrentDate() -> String {
        return Int(Date.timestampWithCurrentDate()).description
    }
    
    //Date类方法转换成时间戳(毫秒)
    static func timestamp(with date: Date) -> TimeInterval {
        return date.timeIntervalSince1970 * 1000
    }
    
    //Date类方法转换成时间戳字符串(毫秒)
    static func timestampString(with date: Date) -> String {
        return Int(Date.timestamp(with: date)).description
    }
    
    //Date转换成时间戳(毫秒)
    func transformIntoTimestamp() -> TimeInterval {
        return self.timeIntervalSince1970 * 1000
    }
    
    //Date转换成时间戳字符串(毫秒)
    func transfromIntoTimestampString() -> String {
        return Int(self.transformIntoTimestamp()).description
    }
    
    //date string(example: "2014-10-01", "2014-10-01 12:01:01")转换成Date
    static func transfromIntoDate(with dateString: String) -> Date {
        let dateFormatter: DateFormatter = DateFormatterSingleton.sharedInstance
        if dateString.characters.count == "2014-10-01".characters.count {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        } else if dateString.characters.count == "2014-10-01 12:01:01".characters.count {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        } else {
            return Date()
        }
        return dateFormatter.date(from: dateString)!
    }
    
    //date string(example: "2014-10-01", "2014-10-01 12:01:01")转换成时间戳
    static func transfromIntoTimestamp(with dateString: String) -> TimeInterval {
        return Date.transfromIntoDate(with: dateString).transformIntoTimestamp()
    }
    
    //date string(example: "2014-10-01", "2014-10-01 12:01:01")转换成时间戳字符串
    static func taransfromIntoTimestampString(with dateString: String) -> String {
        return Int(Date.transfromIntoTimestamp(with: dateString)).description
    }
    
    //日期直接转换成星期
    func weekDescription() -> String {
        let weekdays: Array = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        let calendar: Calendar = Calendar.current
        return weekdays[calendar.component(Calendar.Component.weekday, from: self) - 1]
        
    }
    
    //计算时间过去多久了,超过7天就会直接显示yyyy-MM-dd
    func howLongPassed() -> String {
        let timeInterval: TimeInterval = -self.timeIntervalSinceNow
        
        if timeInterval < 60 {
            return "刚刚"
        } else if timeInterval < 60 * 60  {
            return String.init(format: "%d分钟前", arguments: [Int(timeInterval/60)])
        } else if timeInterval < 60 * 60 * 24 {
            return String.init(format: "%d小时前", arguments: [Int(timeInterval/(60 * 60))])
        } else if timeInterval < 60 * 60 * 24 * 7 {
            return String.init(format: "%d天前", arguments: [Int(timeInterval/(60 * 60 * 24))])
        } else {
            let dateFormatter: DateFormatter = DateFormatterSingleton.sharedInstance
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString: String = dateFormatter.string(from: self)
            return dateString.substring(to: dateString.index(dateString.startIndex, offsetBy: 10))
        }
    
    }
    
}






