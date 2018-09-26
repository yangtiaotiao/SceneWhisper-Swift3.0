//
//  UIImageQRcodeExtension.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/7.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {

    /** 返回一张不超过屏幕尺寸的 image */
    class func imageSize(with screenImage: UIImage) -> UIImage {
        
        let screenImageWidth = screenImage.size.width
        let screenImageHeight = screenImage.size.height
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // 如果读取的二维码照片宽和高小于屏幕尺寸，直接返回原图片
        if (screenImageWidth <= screenWidth && screenImageHeight <= screenHeight) {
            return screenImage;
        }
        
        //HSQRCodeLog(@"压缩前图片尺寸 － width：%.2f, height: %.2f", imageWidth, imageHeight);
        let max = CGFloat.maximum(screenImageWidth, screenImageHeight)
        // 如果是6plus等设备，比例应该是 3.0
        let scale = max / (screenHeight * UIScreen.main.scale)
        //HSQRCodeLog(@"压缩后图片尺寸 － width：%.2f, height: %.2f", imageWidth / scale, imageHeight / scale);
        return UIImage.image(with: screenImage, scaledSize: CGSize(width: screenImageWidth / scale, height: screenImageHeight / scale))
        
    }

    class func image(with image: UIImage, scaledSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: scaledSize.width, height: scaledSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
        
    }
    
}

