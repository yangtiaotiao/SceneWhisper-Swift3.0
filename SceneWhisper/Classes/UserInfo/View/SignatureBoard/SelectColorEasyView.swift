//
//  SelectColorEasyView.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/18.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import UIKit


@objc public protocol SelectColorEasyViewDelegate: NSObjectProtocol {
    
    @objc optional func easyView(_ view: SelectColorEasyView, didSelectColor color: UIColor)
}


public class SelectColorEasyView: UIView {
    
    weak var delegate: SelectColorEasyViewDelegate?
    private var easyColors: NSMutableArray?
    var closeButton: UIButton?
    var selectedButton: UIButton?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init(frame: CGRect, colors: NSArray) {
        
        self.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        easyColors = NSMutableArray()
        
        //最多只取7个
        for i in 0..<colors.count {
            let color = colors[i]
            if easyColors!.count < 7 && color is UIColor {
                easyColors?.add(color)
            }
        }
        
        self.setupViews()
    
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        closeButton?.frame = CGRect(x: self.frame.width - self.frame.height, y: 0.0, width: self.frame.height, height: self.frame.height)
        
    }
    
    func setupViews() {
        
        for i in 0..<easyColors!.count {
            let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
            button.backgroundColor = easyColors![i] as? UIColor
            button.center = CGPoint(x: 20.0 + CGFloat(i) * (30.0 + 15.0) + 15.0, y: 22.0)
            button.tag = i
            button.addTarget(self, action: #selector(selectColorAction(_:)), for: UIControlEvents.touchUpInside)
            self.addSubview(button)
        }
        
        closeButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.height, height: self.frame.height))
        closeButton?.setTitle("X", for: UIControlState.normal)
        closeButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        closeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 30.0)
        closeButton?.addTarget(self, action: #selector(closeViewAction(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(closeButton!)
        
    }
    
    func closeViewAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: strongSelf.frame.height)
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            strongSelf.isHidden = true
            strongSelf.alpha = 1.0
        }
        
    }
    
    func selectColorAction(_ sender: UIButton) {
        
        let color = easyColors?[sender.tag] as! UIColor
        
        sender.layer.borderColor = UIColor.red.cgColor
        sender.layer.borderWidth = 2.0
        
        if selectedButton != nil {
            selectedButton?.layer.borderWidth = 0.0
        }
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SelectColorEasyViewDelegate.easyView(_:didSelectColor:))) {
            self.delegate?.easyView!(self, didSelectColor: color)
        }
        
        selectedButton = sender
    }
    
}









