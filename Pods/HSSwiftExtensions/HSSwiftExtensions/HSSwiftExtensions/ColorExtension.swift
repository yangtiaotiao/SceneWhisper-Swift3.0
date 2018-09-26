//
//  ColorExtension.swift
//  SwiftExtensions
//
//  Created by weipo on 2016/11/1.
//  Copyright © 2016年 weipo. All rights reserved.
//

import Foundation


@available(iOS 8.0, *)

public extension UIColor {

    //通过字符串“#fafafa”，“0xfafafa”获取颜色, alpha透明度，默认1.0
    static func color(with hexString: String, alpha: Float) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
        
        if cString.characters.count < 6 {
            return UIColor.white
        }
        
        if cString.hasPrefix("0X") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
        }
        
        if cString.hasPrefix("#") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        if cString.characters.count != 6 {
            return UIColor.white
        }
        
        var tempRange: Range = cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)
        let rString: String = cString.substring(with: tempRange)
        tempRange = cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)
        let gString: String = cString.substring(with: tempRange)
        tempRange = cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6)
        let bString: String = cString.substring(with: tempRange)
        
        var red: uint = 0
        var green: uint = 0
        var blue: uint = 0
        
        Scanner(string: rString).scanHexInt32(&red)
        Scanner(string: gString).scanHexInt32(&green)
        Scanner(string: bString).scanHexInt32(&blue)
        
        
        return UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
    }
    
    //通过字符串“#fafafa”，“0xfafafa”获取颜色 alpha透明度，默认1.0
    static func color(with hexString: String) -> UIColor {
        return UIColor.color(with: hexString, alpha: 1.0)
    }
    
}



