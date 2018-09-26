//
//  HSCustomSwitch.swift
//  SceneWhisper
//
//  Created by weipo 2017/5/8.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

@objc protocol HSCustomSwitchDelegate: NSObjectProtocol {
    
    @objc optional func switchAction(_ status: Bool)
    
}

enum HSCustomSwitchSliderDirection {
    case left
    case right
}

class HSCustomSwitch: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var switchSlider: UIView?
    var leftLabel: UILabel?
    var rightLabel: UILabel?
    var normalColor: UIColor?
    var highlightColor: UIColor?
    var isOn: Bool = false
    weak var delegate: HSCustomSwitchDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
        
    }
    
    deinit {
        self.delegate = nil
    }
    
    func setupView() {
        
        self.normalColor = UIColor.color(with: "#2d9fe2")
        self.highlightColor = UIColor.white
        
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.borderColor = self.normalColor?.cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.clear
        
        switchSlider = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width/2.0, height: self.frame.height))
        switchSlider?.backgroundColor = self.normalColor
        switchSlider?.layer.cornerRadius = self.frame.height / 2.0
        self.addSubview(switchSlider!)
        
        leftLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.width / 2.0, height: self.frame.height))
        leftLabel?.font = UIFont.systemFont(ofSize: 15.0)
        leftLabel?.textAlignment = NSTextAlignment.center
        leftLabel?.backgroundColor = .clear
        leftLabel?.text = "登录"
        leftLabel?.textColor = self.highlightColor
        self.addSubview(leftLabel!)
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftTapGestureRecognizerHandle(_:)))
        leftTap.numberOfTapsRequired = 1
        leftLabel?.isUserInteractionEnabled = true
        leftLabel?.addGestureRecognizer(leftTap)
        
        rightLabel = UILabel(frame: CGRect(x: self.frame.width / 2.0, y: 0.0, width: self.frame.width / 2.0, height: self.frame.height))
        rightLabel?.font = UIFont.systemFont(ofSize: 15.0)
        rightLabel?.textAlignment = NSTextAlignment.center
        rightLabel?.backgroundColor = .clear
        rightLabel?.text = "注册"
        rightLabel?.textColor = self.normalColor
        self.addSubview(rightLabel!)
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightTapGestureRecognizerHandle(_:)))
        rightTap.numberOfTapsRequired = 1
        rightLabel?.isUserInteractionEnabled = true
        rightLabel?.addGestureRecognizer(rightTap)
        
    }

    func leftTapGestureRecognizerHandle(_ sender: Any) {
        
        if isOn {
            self.switchSliderAnimation(.left)
            self.isOn = false
        } else {
            self.switchFinishCallback()
            //return
        }
    }
    
    func rightTapGestureRecognizerHandle(_ sender: Any) {
        
        if isOn {
            self.switchFinishCallback()
            //return
        } else {
            self.switchSliderAnimation(.right)
            self.isOn = true
        }
    }
    
    func setupViewDirection(_ direction: HSCustomSwitchSliderDirection) {
        if direction == .left {
            self.switchSlider?.frame = CGRect(x: 0.0, y: 0.0, width: (self.switchSlider?.frame.width)!, height: (self.switchSlider?.frame.height)!)
            self.rightLabel?.textColor = self.normalColor
            self.leftLabel?.textColor = self.highlightColor
            isOn = false
            
        } else {
            self.switchSlider?.frame = CGRect(x: self.frame.width / 2.0, y: 0.0, width: (self.switchSlider?.frame.width)!, height: (self.switchSlider?.frame.height)!)
            self.rightLabel?.textColor = self.highlightColor
            self.leftLabel?.textColor = self.normalColor
            isOn = true
        }
    }
    
    func switchSliderAnimation(_ direction: HSCustomSwitchSliderDirection) {
        
        if direction == .left {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.switchSlider?.frame = CGRect(x: 0.0, y: 0.0, width: (strongSelf.switchSlider?.frame.width)!, height: (strongSelf.switchSlider?.frame.height)!)
            }, completion: { [weak self] (finished) in
                guard let strongSelf = self else { return }
                strongSelf.rightLabel?.textColor = strongSelf.normalColor
                strongSelf.leftLabel?.textColor = strongSelf.highlightColor
                strongSelf.switchFinishCallback()
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.switchSlider?.frame = CGRect(x: strongSelf.frame.width / 2.0, y: 0.0, width: (strongSelf.switchSlider?.frame.width)!, height: (strongSelf.switchSlider?.frame.height)!)
                }, completion: { [weak self] (finished) in
                    guard let strongSelf = self else { return }
                    strongSelf.rightLabel?.textColor = strongSelf.highlightColor
                    strongSelf.leftLabel?.textColor = strongSelf.normalColor
                    strongSelf.switchFinishCallback()
            })
        }
    }
    
    func switchFinishCallback() {
        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate?.switchAction(_:))) {
            self.delegate!.switchAction!(self.isOn)
        }
    }
}










