//
//  StringExtension.swift
//  SceneWhisper
//
//  Created by weipo 2017/7/13.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation


extension String {
    
    func Reverse() -> String{
        var returnString: String = ""
        for c in self.characters {
            //returnString.append(self[advance(self.startIndex, i)])
            returnString = "\(c)" + returnString
        }
        
        return returnString
    }
    
    func calculateWidth(_ constrainedSize: CGSize, font: UIFont) -> CGFloat {
        
        var requiredSize: CGSize = CGSize.zero
                
        if Double(UIDevice.current.systemVersion.components(separatedBy: ".").first!)! >= 7.0 {
            
            let requiredFrame: CGRect = (self as NSString).boundingRect(with: constrainedSize, options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: [NSFontAttributeName: font], context: nil)
            requiredSize = requiredFrame.size
        }
        return requiredSize.width
    }
    
    
}
