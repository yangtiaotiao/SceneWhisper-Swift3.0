//
//  UIImageAnnotationImage.swift
//  SceneWhisper
//
//  Created by weipo on 2018/4/9.
//  Copyright © 2018年 weipo. All rights reserved.
//  图片合成

import Foundation
import UIKit


extension UIImage {
    public func annotationImage(userGender:Int) -> UIImage {
        
        //裁剪圆
        let rect1 =  CGRect(x: 0, y: 0, width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(rect1.size, false, 0)
        let Fcontext = UIGraphicsGetCurrentContext()
        Fcontext?.addEllipse(in: rect1)
        Fcontext?.clip()
        self.draw(in: rect1)
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //两图片合并
        let rect2 = CGRect(x: 0, y: 0, width: 45, height: 65)
        UIGraphicsBeginImageContextWithOptions(rect2.size, false, 0)
        var topImage:UIImage?
        if userGender == 1 { // 女（红色）
            topImage = UIImage.init(named: "pin_red_bg")
        } else if userGender == 0 { // 男（蓝色）
            topImage = UIImage.init(named: "pin_blue_bg")
        } else {
            topImage = UIImage.init(named: "pin_gray_bg")
        }
        
        topImage?.draw(in: CGRect(x: 0, y: 0, width: 45, height: 60))
        maskedImage?.draw(in: CGRect(x: 3, y: 3, width: 39, height: 39))
        let composeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return composeImage!
        
    }
    
}
