//
//  SWDateRangeView.swift
//  SceneWhisper
//
//  Created by weipo 2017/9/17.
//  Copyright © 2017年 weipo. All rights reserved.
//  日期-月选择器

import UIKit

class SWDateRangeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var topLabel: UILabel?
    var midLabel: UILabel?
    var bottomLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    func createLabel(_ font: UIFont, location: Int) -> UILabel {
        
        
        let frame = CGRect(x: 0.0, y: 5.0 + CGFloat(location) * 21.0, width: 40.0, height: 21.0)
        let label = UILabel(frame: frame)
        label.font = font
        label.textColor = UIColor.color(with: "#525254")
        label.textAlignment = .center
        
        return label
    }
    
    func setupSubviews() {
        
        let top = createLabel(UIFont.systemFont(ofSize: 12.0), location: 0)
        self.addSubview(top)
        topLabel = top
        
        let mid = createLabel(UIFont.systemFont(ofSize: 8.0), location: 1)
        mid.text = "至"
        self.addSubview(mid)
        midLabel = mid
        
        let bottom = createLabel(UIFont.systemFont(ofSize: 12.0), location: 2)
        self.addSubview(bottom)
        bottomLabel = bottom
        
    }
 
    func loadData(_ top: String, bottom: String, unit: String?) {
    
        var topData = top
        var bottomData = bottom

        if unit != nil {
            topData += unit!
            bottomData += unit!
        }
        topLabel?.text = topData
        bottomLabel?.text = bottomData
        
    }
    
}

