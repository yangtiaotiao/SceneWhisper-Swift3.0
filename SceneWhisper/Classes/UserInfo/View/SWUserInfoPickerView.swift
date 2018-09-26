//
//  SWUserInfoPickerView.swift
//  SceneWhisper
//
//  Created by weipo 2017/10/5.
//  Copyright © 2017年 weipo. All rights reserved.
//  显示头像的采集选择器

import UIKit

@objc protocol SWUserInfoPickerViewDelegate: NSObjectProtocol {
    
    @objc optional func pickerView(_ view: SWUserInfoPickerView, didSelectedAvatarAtIndex index: Int)
    
    @objc optional func pickerView(_ view: SWUserInfoPickerView, didSelectedSexAtIndex index: Int)
    
}

class SWUserInfoPickerView: UIView {

    
    weak var delegate: SWUserInfoPickerViewDelegate?
    var infoType: Int = 0 //0: 头像， 1: 性别
    var mainView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.delegate = nil
    }
    
    convenience init(frame: CGRect, infoType: Int, delegate: SWUserInfoPickerViewDelegate) {
        self.init(frame: frame)
        self.infoType = infoType
        self.delegate = delegate
        setupViews()
    }
    
   func showAtView(_ view: UIView) {
    
        view.window?.addSubview(self)
        
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.mainView?.frame.origin.y = strongSelf.frame.height - 140.0
        }) { (finished) in
            
        }
        
    }
    
    func setupViews() {

        let cancelBtn = UIButton(frame: self.frame)
        cancelBtn.backgroundColor = .clear
        self.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
        
        let mFrame = CGRect(x: 10.0, y: self.frame.height, width: self.frame.width - 20.0, height: 138.0)
        let mView = UIView(frame: mFrame)
        mView.layer.cornerRadius = 5.0
        mView.backgroundColor = .white
        mView.clipsToBounds = true
        self.addSubview(mView)
        mainView = mView
        
        let midLineFrame = CGRect(x: 0.0, y: mFrame.height / 2.0 - 0.5, width: mFrame.width, height: 1.0)
        let midLine = UIView(frame: midLineFrame)
        midLine.backgroundColor = UIColor.color(with: "#dcdcdc")
        mainView?.addSubview(midLine)
        
        let button1Frame = CGRect(x: 0.0, y: 0.0, width: mFrame.width, height: mFrame.height / 2.0)
        let button1 = UIButton(frame: button1Frame)
        button1.tag = 1
        button1.backgroundColor = .clear
        mainView?.addSubview(button1)
        button1.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
        
        let icon1Frame = CGRect(x: mFrame.width / 2.0 - 30.0, y: (button1Frame.height - 25.0) / 2.0, width: 25.0, height: 25.0)
        let icon1 = UIImageView(frame: icon1Frame)
        icon1.contentMode = .center
        button1.addSubview(icon1)
        
        let title1Frame = CGRect(x: mFrame.width / 2.0 + 5.0, y: (button1Frame.height - 25.0) / 2.0, width: 40.0, height: 25.0)
        let title1Label = UILabel(frame: title1Frame)
        button1.addSubview(title1Label)
        
        let button2Frame = CGRect(x: 0.0, y: mFrame.height / 2.0, width: mFrame.width, height: mFrame.height / 2.0)
        let button2 = UIButton(frame: button2Frame)
        button2.tag = 2
        button2.backgroundColor = .clear
        mainView?.addSubview(button2)
        button2.addTarget(self, action: #selector(buttonsAction(_:)), for: .touchUpInside)
        
        let icon2Frame = CGRect(x: mFrame.width / 2.0 - 30.0, y: (button1Frame.height - 25.0) / 2.0, width: 25.0, height: 25.0)
        let icon2 = UIImageView(frame: icon2Frame)
        icon2.contentMode = .center
        button2.addSubview(icon2)
        
        let title2Frame = CGRect(x: mFrame.width / 2.0 + 5.0, y: (button1Frame.height - 25.0) / 2.0, width: 40.0, height: 25.0)
        let title2Label = UILabel(frame: title2Frame)
        button2.addSubview(title2Label)
        
        if infoType == 0 {
            icon1.image = UIImage(named:"w拍照")
            title1Label.text = "照相"
            icon2.image = UIImage(named:"w相册")
            title2Label.text = "相册"
        } else {
            icon1.image = UIImage(named:"w男生icom")
            title1Label.text = "男"
            icon2.image = UIImage(named:"w女生icon")
            title2Label.text = "女"
        }
        
    }
    

    func buttonsAction(_ sender: UIButton) {
        if infoType == 0 {
            UIView.animate(withDuration: 0.1, animations: {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mainView?.frame.origin.y = strongSelf.frame.height
            }, completion: { [weak self] (finished) in
                guard let strongSelf = self else { return }
                if strongSelf.delegate != nil && strongSelf.delegate!.responds(to: #selector(strongSelf.delegate?.pickerView(_:didSelectedAvatarAtIndex:))) {
                    strongSelf.delegate!.pickerView!(strongSelf, didSelectedAvatarAtIndex: sender.tag)
                }
                strongSelf.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: 0.1, animations: {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.mainView?.frame.origin.y = strongSelf.frame.height
            }, completion: {[weak self] (finished) in
                guard let strongSelf = self else { return }
                if strongSelf.delegate != nil && strongSelf.delegate!.responds(to: #selector(strongSelf.delegate?.pickerView(_:didSelectedSexAtIndex:))) {
                    strongSelf.delegate!.pickerView!(strongSelf, didSelectedSexAtIndex: sender.tag)
                }
                strongSelf.removeFromSuperview()
            })
        }
    }
    
    func cancelBtnAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.1, animations: {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.mainView?.frame.origin.y = strongSelf.frame.height
        }) {[weak self] (finished) in
            guard let strongSelf = self else { return }
            strongSelf.removeFromSuperview()
        }
    }
    
}







