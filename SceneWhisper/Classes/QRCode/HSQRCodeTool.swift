//
//  HSQRCodeTool.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/10.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import CoreImage
import AVFoundation
import UIKit

class HSQRCodeTool: NSObject {
    
    /** 根据CIImage生成指定大小的UIImage */
    class func createNonInterpolatedUIImage(frome CIImage: CIImage, size: CGFloat) -> UIImage {
        
        let extent = CIImage.extent.integral
        let scale = CGFloat.minimum(size / extent.width, size / extent.height)
        
        //1.创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale
        let cs = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: bitmapInfo.rawValue)
        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(CIImage, from: extent)
        bitmapRef!.interpolationQuality = CGInterpolationQuality.none
        bitmapRef!.scaleBy(x: scale, y: scale)
        bitmapRef?.draw(bitmapImage!, in: extent)
        
        //2.保存bitmap到图片
        let scaledImage = bitmapRef!.makeImage()
        
        return UIImage(cgImage: scaledImage!)
    }

    /**
     *  生成一张普通的二维码
     *
     *  @param QRCodeData    传入你要生成二维码的数据
     *  @param imageViewWidth    图片的宽度
     */
    class func generate(_ QRCodeData: String, imageViewWidth: CGFloat) -> UIImage {
        
        // 1、创建滤镜对象
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜的默认属性
        filter?.setDefaults()
        
        // 2、设置数据
        let infoData = QRCodeData.data(using: String.Encoding.utf8)
        
        // 通过KVC设置滤镜inputMessage数据
        filter?.setValue(infoData, forKey: "inputMessage")
        
        // 3、获得滤镜输出的图像
        let outputImage = filter?.outputImage
        
        return HSQRCodeTool.createNonInterpolatedUIImage(frome: outputImage!, size: imageViewWidth)
        
    }
    
    /** 生成一张带有logo的二维码（logoScaleToSuperView：相对于父视图的缩放比取值范围0-1；0，不显示，1，代表与父视图大小相同） */
    class func generate(_ QRCodeData: String, logoImage: UIImage, logoScale: CGFloat) -> UIImage {
        
        // 1、创建滤镜对象
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜的默认属性
        filter?.setDefaults()
        
        // 2、设置数据
        let infoData = QRCodeData.data(using: String.Encoding.utf8)
        
        // 通过KVC设置滤镜inputMessage数据
        filter?.setValue(infoData, forKey: "inputMessage")
        
        // 3、获得滤镜输出的图像
        var outputImage = filter?.outputImage
        
        // 图片小于(27,27),我们需要放大
        outputImage = outputImage?.applying(CGAffineTransform(scaleX: 20.0, y: 20.0))
        
        // 4、将CIImage类型转成UIImage类型
        let startImage = UIImage(ciImage: outputImage!)
        
        // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
        UIGraphicsBeginImageContext(startImage.size)
        
        // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
        startImage.draw(in: CGRect(x: 0.0, y: 0.0, width: startImage.size.width, height: startImage.size.height))
        
        // 再把小图片画上去
        let iconWidth = startImage.size.width * logoScale
        let iconHeight = startImage.size.height * logoScale
        let iconOriginalX = (startImage.size.width - iconWidth) * 0.5
        let iconOriginalY = (startImage.size.height - iconHeight) * 0.5
        
        logoImage.draw(in: CGRect(x: iconOriginalX, y: iconOriginalY, width: iconWidth, height: iconHeight))
        
        // 6、获取当前画得的这张图片
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 7、关闭图形上下文
        UIGraphicsEndImageContext()
        
        return finalImage!
        
    }
    
    /** 生成一张彩色的二维码 */
    class func generate(_ QRCodeData: String, backgroundColor: CIColor, mainColor: CIColor) -> UIImage {
        
        // 1、创建滤镜对象
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜的默认属性
        filter?.setDefaults()
        
        // 2、设置数据
        let infoData = QRCodeData.data(using: String.Encoding.utf8)
        
        // 通过KVC设置滤镜inputMessage数据
        filter?.setValue(infoData, forKey: "inputMessage")
        
        // 3、获得滤镜输出的图像
        var outputImage = filter?.outputImage
        
        // 图片小于(27,27),我们需要放大
        outputImage = outputImage?.applying(CGAffineTransform(scaleX: 9.0, y: 9.0))
        
        // 4、创建彩色过滤器(彩色的用的不多)
        let colorFilter = CIFilter(name: "CIFalseColor")
        
        colorFilter?.setDefaults()
        
        // 5、KVC 给私有属性赋值
        colorFilter?.setValue(outputImage, forKey: "inputImage")
        
        // 6、需要使用 CIColor
        colorFilter?.setValue(backgroundColor, forKey: "inputColor0")
        colorFilter?.setValue(mainColor, forKey: "inputColor1")
        
        // 7、设置输出
        let colorImage = colorFilter?.outputImage
        
        return UIImage(ciImage: colorImage!)
        
    }
}










