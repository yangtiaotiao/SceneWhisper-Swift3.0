//
//  UIImageExtension.swift
//  SwiftExtensions
//
//  Created by weipo on 2016/11/1.
//  Copyright © 2016年 weipo. All rights reserved.
//

import Foundation


@available(iOS 8.0, *)

public extension UIImage {

    /**
     * @param markImage 水印图
     * @param originalImage 要加水印的原图
     * @param point 水印加在原图的坐标点
     */
    static func addMarkImage(_ markImage: UIImage, to originalImage: UIImage, at point: CGPoint) -> UIImage? {
    
        var tempPoint: CGPoint = point
        
        guard point.x >= 0 && point.y >= 0  else {
            print("x of point must be greater than and equal to zero ,And y of point must be greater  than and equal to zero")
            return originalImage
        }
        
        if originalImage.size.height < (point.y + markImage.size.height) {
            tempPoint.y = originalImage.size.height - markImage.size.height
        }
        
        if originalImage.size.width < (point.x + markImage.size.width) {
            tempPoint.x = originalImage.size.width - markImage.size.width
        }
        
        UIGraphicsBeginImageContext(originalImage.size)
        originalImage.draw(in: CGRect.init(x: 0.0, y: 0.0, width: originalImage.size.width, height: originalImage.size.height))
        markImage.draw(in: CGRect.init(x: tempPoint.x, y: tempPoint.y, width: markImage.size.width, height: markImage.size.height))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    
    
}





