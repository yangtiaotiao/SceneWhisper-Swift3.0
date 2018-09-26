//
//  HSCustomSearchBar.swift
//  SceneWhisper
//
//  Created by weipo 2017/7/13.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

@objc protocol HSCustomSearchBarDelegate: NSObjectProtocol {
    
    @objc optional func searchBarShouldBeginEditing(_ searchBar: HSCustomSearchBar)
    
    @objc optional func searchBarShouldEndEditing(_ searchBar: HSCustomSearchBar )
    @objc optional func searchBarShouldReturn(_ searchBar: HSCustomSearchBar )
    
}

class HSCustomSearchBar: UIView {

    var backgroundImage: UIImageView?
    var searchIcon: UIImageView?
    var textField: UITextField?
    var placeholder: UILabel?
    weak var delegate: HSCustomSearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.createView()
    }
    
    func createView() {
        
        self.backgroundColor = .clear
        
        let bgImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        bgImageView.image = UIImage(named: "秘信列表搜索框")
        self.addSubview(bgImageView)
        self.backgroundImage = bgImageView
        
        let tf = UITextField(frame: CGRect(x: 10.0, y: 0.0, width: self.frame.width - 20.0, height: self.frame.height))
        tf.borderStyle = .none
        tf.delegate = self
        tf.textColor = .white
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 11.0)
        self.addSubview(tf)
        self.textField = tf
        textField?.returnKeyType = .search
        
        
        let keywordLength = "输入搜索关键字".calculateWidth(self.frame.size, font: UIFont.systemFont(ofSize: 9.0))
      
        let MidLength = 13.0 + 3.0 + keywordLength
        
        let locX = (self.frame.width - MidLength) / 2.0
        
        let pLabel = UILabel(frame: CGRect(x: locX + 16.0, y: (self.frame.height - 17.0) / 2.0, width: keywordLength, height: 17.0))
        pLabel.textColor = .white
        pLabel.text = "输入搜索关键字"
        pLabel.font = UIFont.systemFont(ofSize: 9.0)
        self.addSubview(pLabel)
        self.placeholder = pLabel
        
        
        let icon  = UIImageView(frame: CGRect(x: locX, y: (self.frame.height - 13.0) / 2.0, width: 13.0, height: 13.0))
        icon.image = UIImage(named: "秘信列表搜索")
        self.addSubview(icon)
        self.searchIcon = icon
        
    }
    
}

extension HSCustomSearchBar: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.searchIcon?.isHidden = true
        self.placeholder?.isHidden = true
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate!.searchBarShouldBeginEditing(_:))) {
            self.delegate!.searchBarShouldBeginEditing!(self)
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate!.searchBarShouldEndEditing(_:))) {
            self.delegate!.searchBarShouldEndEditing!(self)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" {
            self.searchIcon?.isHidden = false
            self.placeholder?.isHidden = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate!.searchBarShouldReturn(_:))) {
            self.delegate!.searchBarShouldReturn!(self)
        }
        
        return true
    }
}
