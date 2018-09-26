//
//  HSCustomCompassView.swift
//  SceneWhisper
//
//  Created by weipo 2017/12/21.
//  Copyright © 2017年 weipo. All rights reserved.
//  纬度指示控件

import UIKit
import CoreLocation

public enum HSCustomCompassStyle {
    case latitude
    case longitude
}

private let width: CGFloat = 88.0
private let height: CGFloat = 118.0

class HSCustomCompassView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var compassImage: UIImageView?
    var dataLabel: UILabel?
    var needle: UIView?
    var centerPoint: UIView?
    private var viewStyle: HSCustomCompassStyle?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ original: CGPoint, style: HSCustomCompassStyle) {
        
        self.init(frame: CGRect(x: original.x, y: original.y, width: width, height: height))
        compassImage = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 88.0, height: 88.0))
        self.addSubview(compassImage!)
        dataLabel = UILabel(frame: CGRect(x: 0.0, y: 88.0, width: 88.0, height: 30.0))
        dataLabel?.backgroundColor = .clear
        dataLabel?.textAlignment = .center
        self.addSubview(dataLabel!)
        
        needle = UIView(frame: CGRect(x: (width - 46.0) / 2.0, y: (width - 1.0) / 2.0, width: 46.0, height: 1.0))
        needle?.backgroundColor = UIColor.color(with: "#545f6c")
        needle?.layer.allowsEdgeAntialiasing = true
        self.addSubview(needle!)
        
        centerPoint = UIView(frame: CGRect(x: (width - 5.0) / 2.0, y:  (width - 5.0) / 2.0, width: 5.0, height: 5.0))
        centerPoint?.layer.cornerRadius = 2.5
        
        self.addSubview(centerPoint!)
        
        if style == .latitude {
            compassImage?.image = UIImage(named: "latitudeIcon")
            centerPoint?.backgroundColor = UIColor.color(with: "#88ff6a")
        } else {
            compassImage?.image = UIImage(named: "longitudeIcon")
            centerPoint?.backgroundColor = UIColor.color(with: "ffe26a")
        }
        viewStyle = style
        
    }
    
    //加载经纬度数据
    func loadData(_ coordinate: CLLocationCoordinate2D) {
        
        var title: String? = "N:45°28‘25“"
        if viewStyle == .latitude {
            title = coordinate.NorthOrSouth() + ":" + coordinate.latitudeString()
            //needle?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * coordinate.latitude / 180.0) - CGFloat(Double.pi / 12.0) + CGFloat(Double.pi * 2.0))
//            let transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * coordinate.latitude / 180.0) - CGFloat(Double.pi / 12.0) + CGFloat(Double.pi * 1.0))
            let transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 1.28))
            UIView.beginAnimations("latitudeRotate", context: nil)
            UIView.setAnimationDuration(2.0)
            needle?.transform = transform
            UIView.commitAnimations()
        } else {
            title = coordinate.EastOrWest() + ":" + coordinate.longitudeString()
            //needle?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * coordinate.longitude / 180.0) - CGFloat(Double.pi / 12.0) + CGFloat(Double.pi * 2.0))
            let transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 1.4))
            UIView.beginAnimations("longitudeRotate", context: nil)
            UIView.setAnimationDuration(2.0)
            needle?.transform = transform
            UIView.commitAnimations()
        }
        let attributeText = NSMutableAttributedString(string: title!)
        attributeText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 11.0), NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, 2))
        attributeText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 11.0), NSForegroundColorAttributeName: UIColor.color(with: "#bcbdba")], range: NSMakeRange(2, title!.count - 2))
        dataLabel?.attributedText = attributeText
        
        
        
    }
    
}







