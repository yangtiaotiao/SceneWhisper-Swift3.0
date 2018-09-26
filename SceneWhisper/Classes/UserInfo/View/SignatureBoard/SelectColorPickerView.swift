//
//  SelectColorPickerView.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/18.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


@objc public protocol SelectColorPickerViewDelegate: NSObjectProtocol {
    
    @objc optional func pickerView(_ view: SelectColorPickerView, didPickColor color: UIColor)
    
}


public class SelectColorPickerView: UIView {
    
    weak var delegate: SelectColorPickerViewDelegate?
    var backImageView: UIImageView?
    var centerImageView: UIImageView?
    var closeButton: UIButton?
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        closeButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.height, height: self.frame.height))
        closeButton?.setTitle("X", for: UIControlState.normal)
        closeButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        closeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 30.0)
        closeButton?.addTarget(self, action: #selector(closeViewAction(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(closeButton!)
        
        
        
        centerImageView = UIImageView(frame: CGRect(x: self.pickerCenter().x - 15.0, y: self.pickerCenter().y - 15.0, width: 30.0, height: 30.0))
        centerImageView?.image = UIImage(named: "point.png")
        self.addSubview(centerImageView!)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        closeButton?.frame = CGRect(x: self.boundWidth() - 50.0, y: 0.0, width: 50.0, height: 50.0)
    }
    
    func closeViewAction(_ sender: UIButton) {
        self.isHidden = true
    }
    
    func boundWidth() -> CGFloat {
        return self.bounds.size.width
    }
    
    func boundHeight() -> CGFloat {
        return self.bounds.size.height
    }
    
    func pickerCenter() -> CGPoint {
        return CGPoint(x: self.boundWidth() / 2.0, y: self.boundHeight() / 2.0)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let centerImage = UIImage(named: "ColorPalette.png")
        centerImage?.draw(in: CGRect(x: 20.0, y: (self.boundHeight() - (self.boundWidth() - 40.0)) / 2.0, width: self.boundWidth() - 40.0, height: self.boundHeight() - 40.0))
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let currentPoint = touch.location(in: self)
        let chassRadius = (self.boundWidth() - 20.0) * 0.5
        let absDistanceX = fabs(currentPoint.x - self.pickerCenter().x)
        let absDistanceY = fabs(currentPoint.y - self.pickerCenter().y)
        let currentToPointRadius = sqrtf(Float(absDistanceX * absDistanceX + absDistanceY * absDistanceY))
        
        if CGFloat(currentToPointRadius) < chassRadius {
            self.centerImageView?.center = currentPoint
            let color = self.pickPixelColorAtLocation(currentPoint)
            if self.delegate != nil && self.delegate!.responds(to: #selector(SelectColorPickerViewDelegate.pickerView(_:didPickColor:)))  {
                self.delegate?.pickerView!(self, didPickColor: color!)
            }
        }
        
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let currentPoint = touch.location(in: self)
        let chassRadius = (self.boundWidth() - 20.0) * 0.5 - self.boundWidth() / 20.0
        let absDistanceX = fabs(currentPoint.x - self.pickerCenter().x)
        let absDistanceY = fabs(currentPoint.y - self.pickerCenter().y)
        let currentToPointRadius = sqrtf(Float(absDistanceX * absDistanceX + absDistanceY * absDistanceY))
        
        if CGFloat(currentToPointRadius) < chassRadius {
            self.centerImageView?.center = currentPoint
            let color = self.pickPixelColorAtLocation(currentPoint)
            if self.delegate != nil && self.delegate!.responds(to: #selector(SelectColorPickerViewDelegate.pickerView(_:didPickColor:)))  {
                self.delegate?.pickerView!(self, didPickColor: color!)
            }
        }

    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //这句话可以去掉，去掉的话就必须点击右上角叉叉关闭
        self.isHidden = true
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func pickPixelColorAtLocation(_ point: CGPoint) -> UIColor? {
        
        var color: UIColor? = nil
        UIGraphicsBeginImageContext(self.bounds.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        let inImage = viewImage?.cgImage
        
        let cgctx = self.createARGBBitmapContextFromImage(inImage!)
        
        let width = self.bounds.width
        let height = self.bounds.height
        
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        cgctx.draw(inImage!, in: rect)
        let data = cgctx.data!
        
        let offset: Int = Int(4 * ((width * round(point.y)) + round(point.x)))
        let alpha =  data.load(fromByteOffset: offset, as: UInt8.self)
        let red = data.load(fromByteOffset: offset + 1, as: UInt8.self)
        let green =  data.load(fromByteOffset: offset + 2, as: UInt8.self)
        let blue =  data.load(fromByteOffset: offset + 3, as: UInt8.self)
       
        color = UIColor(colorLiteralRed: Float(red) / 255.0, green: Float(green) / 255.0, blue: Float(blue) / 255.0, alpha: Float(alpha) / 255.0)
        
        return color
    }
    
    func createARGBBitmapContextFromImage(_ inImage: CGImage) -> CGContext {
        
        let pixelsWide = self.bounds.size.width
        let pixelsHigh = self.bounds.size.height
        let bitmapBytesPerRow = pixelsWide * 4
        let bitmapByteCount = Int(bitmapBytesPerRow) * Int(pixelsHigh)
        
        print(pixelsWide, pixelsHigh, bitmapBytesPerRow, bitmapByteCount)
        
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let size = CGSize(width: CGFloat(pixelsWide), height: CGFloat(pixelsHigh))
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let context = CGContext(data: bitmapData, width: Int(pixelsWide), height: Int(pixelsHigh), bitsPerComponent: 8, bytesPerRow: Int(bitmapBytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        return context!
    }
    
}













