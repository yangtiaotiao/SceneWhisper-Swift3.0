//
//  StringExtension.swift
//  SwiftExtensions
//
//  Created by weipo on 2016/10/27.
//  Copyright © 2016年 weipo. All rights reserved.
//

import Foundation

@available(iOS 8.0, *)

public extension String {

    //是否是移动电话号码
    func isMobilePhone() -> Bool {
        let regex: String = "1[0-9]{10}"
        let predicate: NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", argumentArray: [regex])
        return predicate.evaluate(with: self)
        
    }
    
    //是否是有效邮件
    func isValidEmail() -> Bool {
        let regex: String = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9._%+-]+\\.[A-Za-z0-9._%+-]+$"
        let predicate: NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", argumentArray: [regex])
        return predicate.evaluate(with: self)
    }
    
    //是否是全数字字符串
    func isAllDigital() -> Bool {
        let regex: String = ".*[0-9].*"
        let predicate: NSPredicate = NSPredicate.init(format: "SELF MATCHES %@", argumentArray: [regex])
        return predicate.evaluate(with: self)
    }
    
    //对URL的字符串的中文或者其他非法字符进行转码
    func URLEncodeString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    //检查并修复sql语句中参数带有非法字符“‘”
    static func checkSqlParam(_ param: String?) -> String {
        if param == nil {
            return ""
        }
        var tempString: String = String()
        if param?.contains("'") == true {
            for  c in (param?.characters)! {
                if c == "'" {
                    tempString += "''"
                } else {
                    tempString.append(c)
                }
            }
            return tempString
        } else {
            return param!
        }
    }
    
    //根据字体和限制宽度计算字符串的高度
    func calculateHeight(with width: Float, font: UIFont) -> Float {
        var requiredSize: CGSize = CGSize.zero
        let boundingSize: CGSize = CGSize(width: Double(width), height: Double(CGFloat.greatestFiniteMagnitude))
        if Float(UIDevice.current.systemVersion)! >= Float(7.0) {
            let requiredFrame: CGRect = (self as NSString).boundingRect(with: boundingSize, options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: [NSFontAttributeName: font], context: nil)
            requiredSize = requiredFrame.size
        }
        return Float(requiredSize.height)
    }
    
    //根据字体和限制size计算字符串的高度
    func calculateHeight(with constrainedSize: CGSize, font: UIFont) -> Float {
        var requiredSize: CGSize = CGSize.zero
        if Float(UIDevice.current.systemVersion)! >= Float(7.0) {
            let requiredFrame: CGRect = (self as NSString).boundingRect(with: constrainedSize, options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: [NSFontAttributeName: font], context: nil)
            requiredSize = requiredFrame.size
        }
        return Float(requiredSize.height)
    }
    
    //根据时间字符串转计算已经过了多久,超过7天就会直接显示yyyy-MM-dd
    static func howLongPassed(with dateString: String) -> String {
        let date: Date = Date.transfromIntoDate(with: dateString)
        let timeInterval: TimeInterval = -date.timeIntervalSinceNow
        
        if timeInterval < 60 {
            return "刚刚"
        } else if timeInterval < 60 * 60  {
            return String.init(format: "%d分钟前", arguments: [Int(timeInterval/60)])
        } else if timeInterval < 60 * 60 * 24 {
            return String.init(format: "%d小时前", arguments: [Int(timeInterval/(60 * 60))])
        } else if timeInterval < 60 * 60 * 24 * 7 {
            return String.init(format: "%d天前", arguments: [Int(timeInterval/(60 * 60 * 24))])
        } else {
            return dateString.substring(to: dateString.index(dateString.startIndex, offsetBy: 10))
        }
        
    }
    
        
}




