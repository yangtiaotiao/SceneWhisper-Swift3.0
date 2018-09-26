//
//  SWCustomSliderView.swift
//  SceneWhisper
//
//  Created by weipo 2017/8/14.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

@objc protocol SWCustomSliderViewDelegate: NSObjectProtocol {
    
//    @objc optional func sliderView(_ view: SWCustomSliderView, changToPercent percent: Double)
    @objc optional func sliderView(_ view: SWCustomSliderView, didEndedSlideTo percent: Double)
}

class SWCustomSliderView: UIView {

    var totalView: UIView?
    var progressView: UIView?
    var minButton: UIButton?
    var maxButton: UIButton?
    var backgroundImage: UIImageView?
    var thumbView: UIView?
    var currentValue: Double? = 0.0
    var maximum: Double? = 1.0
    var minimum: Double? = 0.0
    var minTrackColor: UIColor = UIColor.red
    var maxTrackColor: UIColor = UIColor.white
    var deepColor: UIColor?
    var lightColor: UIColor?
    var calibration: UILabel?
    var buoy: UIImageView?
    var trackHeight: CGFloat? = 3.0
    var unitString: String?
    weak var delegate: SWCustomSliderViewDelegate?
    fileprivate var minLocation: CGFloat? = 0.0
    fileprivate var maxLocation: CGFloat? = 1.0
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.delegate = nil
    }
    
    convenience init(frame: CGRect, isShowUpdateButton: Bool, current: Double, minMum:Double, maxMum: Double, unit: String?) {
        self.init(frame: frame)
        
        if unit != nil {
            self.unitString = unit
        }
        
        self.minimum = minMum
        self.maximum = maxMum
        self.currentValue = current
     
        //背景
        let imageView = UIImageView(image: UIImage(named: "3圆角矩形框"))
        self.backgroundImage = imageView
        self.addSubview(imageView)
        self.backgroundImage?.center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        
        var startX: CGFloat = 10.0
        
        //totalView
        if isShowUpdateButton {
            startX = 30.0
            
            //minButton
            let minBtn = UIButton(type: .custom)
            minBtn.frame = CGRect(x: 10.0, y: (frame.height - 20.0) / 2.0, width: 20.0, height: 20.0)
            minBtn.setTitle("-", for: .normal)
            minBtn.setBackgroundImage(UIImage(named:"3圆默认"), for: .normal)
            minBtn.setBackgroundImage(UIImage(named:"3圆点击"), for: UIControlState.highlighted)
            minBtn.addTarget(self, action: #selector(minButtonAction(_:)), for: .touchUpInside)
            self.addSubview(minBtn)
            self.minButton = minBtn
            
            //maxButton
            let maxBtn = UIButton(type: .custom)
            maxBtn.frame = CGRect(x: frame.width - startX, y: (frame.height - 20.0) / 2.0, width: 20.0, height: 20.0)
            maxBtn.setTitle("+", for: .normal)
            maxBtn.setBackgroundImage(UIImage(named:"3圆默认"), for: .normal)
            maxBtn.setBackgroundImage(UIImage(named:"3圆点击"), for: UIControlState.highlighted)
            maxBtn.addTarget(self, action: #selector(maxButtonAction(_:)), for: .touchUpInside)
            self.addSubview(maxBtn)
            self.maxButton = maxBtn
            
            //minCalibration
            let minCal = UILabel(frame: CGRect(x: minButton!.frame.minX, y: backgroundImage!.frame.maxY, width: minButton!.frame.width, height: 10.0))
            minCal.textColor = UIColor.white
            minCal.textAlignment = .center
            minCal.font = UIFont.systemFont(ofSize: 8.0)
            self.addSubview(minCal)
            
            //maxCalibration
            let maxCal = UILabel(frame: CGRect(x: maxButton!.frame.minX - 5.0, y: backgroundImage!.frame.maxY, width: 30.0, height: 10.0))
            maxCal.textColor = UIColor.white
            maxCal.textAlignment = .center
            maxCal.font = UIFont.systemFont(ofSize: 8.0)
            self.addSubview(maxCal)
            
            
            if unit != nil {
                minCal.text = Int(minMum).description + unit!
                maxCal.text = Int(maxMum).description + unit!
            } else {
                minCal.text = Int(minMum).description
                maxCal.text = Int(maxMum).description
            }
            
            
        } else {
            startX = 20.0;
        }
        
        let tView = UIView(frame: CGRect(x: startX, y: (frame.height - trackHeight!) / 2.0, width: frame.width - startX * 2.0, height: trackHeight!))
        tView.backgroundColor = maxTrackColor
        tView.layer.cornerRadius = trackHeight! / 2.0
        self.addSubview(tView)
        self.totalView = tView
        
        //progressView
        let pView = UIView(frame: CGRect(x: startX, y: (frame.height - trackHeight!) / 2.0, width: tView.frame.width * CGFloat(current), height: trackHeight!))
        pView.layer.cornerRadius = trackHeight! / 2.0
        pView.backgroundColor = minTrackColor
        self.addSubview(pView)
        self.progressView = pView
        
        //thumbView （原点指示位置）
        let thView = UIView(frame: CGRect(x: pView.frame.maxX - 25, y: (frame.height - 50.0) / 2.0, width: 50.0, height: 50.0))
        thView.backgroundColor = UIColor.clear
        let redImage = UIImageView(frame: CGRect(x: (thView.bounds.width - 14)/2.0, y: (thView.bounds.height - 14)/2.0, width: 14, height: 14))
        redImage.image = UIImage.init(named: "3位置icon点")
        redImage.layer.cornerRadius = 7.0
        redImage.layer.borderColor = UIColor.white.cgColor
        redImage.layer.borderWidth = 1.0
        redImage.backgroundColor = minTrackColor
        
        thView.addSubview(redImage);
        self.addSubview(thView)
        self.thumbView = thView
        
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        panGesture.maximumNumberOfTouches = 1
        self.thumbView?.addGestureRecognizer(panGesture)
        
        //calibration
        let label: UILabel = UILabel(frame: CGRect(x: thView.frame.midX - 15.0, y: thView.bounds.height, width: 30.0, height: 10.0))
        label.textColor = minTrackColor
        label.font = UIFont.systemFont(ofSize: 8.0)
        if unit != nil {
            label.text = Int((maxMum - minMum) * current).description + unit!
        } else {
            label.text = Int((maxMum - minMum) * current).description
        }
        label.textAlignment = .center
        self.addSubview(label)
        self.calibration = label
//        self.calibration?.addGestureRecognizer(panGesture)
        
        //buoy
        let buoyImage: UIImageView = UIImageView(image: UIImage(named: "3位置icon"))
        buoyImage.center = CGPoint(x: thView.frame.midX, y: frame.height / 2.0 - thView.frame.height / 2.0 - buoyImage.frame.height / 2.0 + 15)
        self.addSubview(buoyImage)
        self.buoy = buoyImage
        
        self.minLocation = totalView!.frame.minX
        self.maxLocation = totalView!.frame.maxX - thumbView!.frame.width
        
        
    }
    
    // 减按钮事件
    func minButtonAction(_ sender: UIButton) {
        
        currentValue! -= 0.05
        if currentValue! < 0.0 {
            currentValue! =  0.0
        }
        
        setupViews(currentValue!)
        
    }
    
    // 增按钮事件
    func maxButtonAction(_ sender: UIButton) {
    
        currentValue! += 0.05
        if currentValue! > 1.0 {
            currentValue! = 1.0
        }
        
        setupViews(currentValue!)
        
    }

    // 定位拖拽事件
    func panGestureHandler(_ sender: UIPanGestureRecognizer) {
        
        let panPoint = sender.location(in: self)
        print("panPoint: \(panPoint.x)")
        switch sender.state {
        case .began:
            
            buoy?.isHidden = true
            
            break
        case .changed:
            
            currentValue = Double((panPoint.x - minLocation!) / (maxLocation! - minLocation!))

            if panPoint.x <= minLocation!  {
                currentValue = 0.0
            }
            
            if panPoint.x >= maxLocation! {
                currentValue = 1.0
            }
            
            setupViews(currentValue!)
            
            
            break
        case .ended:
            
            buoy?.isHidden = false
            if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate!.sliderView(_:didEndedSlideTo:))) {
                self.delegate!.sliderView!(self, didEndedSlideTo: currentValue!)
            }
            
            break
        case .cancelled:
            
            break
        default:
            break
        }
    }
    
    func setupViews(_ percent: Double) {
        
        let originX: CGFloat = minLocation! + (maxLocation! - minLocation!) * CGFloat(percent)
        
        thumbView?.frame.origin.x = originX
        calibration?.center = CGPoint(x: thumbView!.center.x, y: calibration!.center.y)
        buoy?.center = CGPoint(x: thumbView!.center.x, y: buoy!.center.y)
        
        
        progressView!.frame.size.width = (maxLocation! - minLocation!) * CGFloat(percent) + 25;
        
        if unitString != nil {
            calibration?.text = Int(minimum! + (maximum! - minimum!) * percent).description + unitString!
        } else {
            calibration?.text = Int(minimum! + (maximum! - minimum!) * percent).description
        }
        // 代理事件
        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate!.sliderView(_:didEndedSlideTo:))) {
            self.delegate!.sliderView!(self, didEndedSlideTo: currentValue!)
        }
        
    }
    
}
