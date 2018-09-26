//
//  HomeBottomLocationAddressView.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/20.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

class HomeBottomLocationAddressView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var icon: UIImageView?
    var addressLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        icon = UIImageView(frame: CGRect(x: 5.0, y: 10.5, width: 11.0, height: 14.0))
        icon?.image = UIImage(named: "cityLocationIcon")
        self.addSubview(icon!)
        addressLabel = UILabel(frame: CGRect(x: 22.0, y: 7.0, width: 127.0, height: 21.0))
        addressLabel?.textColor = .white
        addressLabel?.font = UIFont.systemFont(ofSize: 11.0)
        self.addSubview(addressLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //查看是否需要更换地址信息
    func changeAddress(_ address: String) {
        
        if address == self.addressLabel?.text {
            return;
        }
        
        let size = (address as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11.0)])
        let screenFrame = UIScreen.main.bounds
        var width: CGFloat = size.width
        if width > screenFrame.width - 70.0 {
            width = screenFrame.width - 70.0
        }
        
        self.addressLabel?.frame = CGRect(x: 22.0, y: 7.0, width: size.width, height: 21.0)
        self.addressLabel?.text = address
        self.frame = CGRect(x: (screenFrame.width - width) / 2.0, y: screenFrame.height - 35.0, width: width, height: 35.0)
        
    }
    
}
