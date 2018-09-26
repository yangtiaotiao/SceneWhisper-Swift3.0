//
//  HSScrollMenu.swift
//  SceneWhisper
//
//  Created by weipo 2017/6/23.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit
import Foundation

@objc protocol HSScrollMenuDelegate: NSObjectProtocol {
    
    @objc optional func scrollMenu(didSelectdItem tag: Int)
    
}


class HSScrollMenu: UIView {

    
    var isInfinited: Bool? = false
    fileprivate var items: NSMutableArray?
    var contentView: UIScrollView?
    private var showAccount: Int? = 3
    private var itemSize: CGSize?
    var itemInfos: Array<Dictionary<String, Any>>?
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: 3.0 * frame.width + frame.width * 2.0 / 3.0, height: frame.height)
        scrollView.delegate = self
//        scrollView.backgroundColor = UIColor.yellow
        self.addSubview(scrollView)
        self.contentView = scrollView
        
        self.items = NSMutableArray()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect, items: Array<Dictionary<String, Any>>, isInfinited: Bool, showAccount: Int, itemSize: CGSize) {
        
        self.init(frame: frame)
        self.createSubViews(items, isInfinited: isInfinited, showAccount: showAccount, itemSize: itemSize)
        
    }
    
    func createSubViews(_ items: Array<Dictionary<String, Any>>, isInfinited: Bool, showAccount: Int, itemSize: CGSize) {
        
        if items.count == 0 {
            return;
        }
        
        self.isInfinited = isInfinited
        self.showAccount = showAccount
        self.itemSize = itemSize
        self.itemInfos = items
        
        for i in 0..<items.count {
            
            let itemInfo = items[i]
            let itemImage = UIImage(named: itemInfo["image"] as! String)
            let item = self.createItemView(itemImage!, title: nil, frame: nil, tag: i)
            contentView?.addSubview(item)
            self.items?.add(item)
            
        }
        
    }
    
    func createItemView(_ image: UIImage, title: String?, frame: CGRect?, tag: Int) -> UIView {
        let button = UIButton(type: .custom)
        button.tag = tag
        let width = self.frame.width
        let offSizeX = fabs(width / 6.0 * CGFloat(2 * tag + 1) - width / 2.0 - contentView!.contentOffset.x)
        let offSizeY = sqrt(fabs(width * width / 4.0 - offSizeX * offSizeX))
        print("offsizey: \(offSizeY)")
        button.center = CGPoint(x: width / 6.0 * CGFloat(2 * tag + 1), y: width / 2.0 - offSizeY + width / 4.0)
        button.bounds = CGRect(x: 0.0, y: 0.0, width: (width / 2.0 - offSizeX) / (width / 2.0) * 40.0 + 20.0, height: (width / 2.0 - offSizeX) / (width / 2.0) * 40.0 + 20.0)
        button.addTarget(self, action: #selector(itemViewClicked(_:)), for: UIControlEvents.touchUpInside)
        button.setBackgroundImage(image, for: .normal)
//        button.backgroundColor = UIColor.blue
        return button
    }
    
    func itemViewClicked(_ sender: UIButton) {
        
        contentView?.setContentOffset(CGPoint(x: self.frame.width / 3.0 * CGFloat(sender.tag - 1), y: 0), animated: true)
        
    }
    
}



extension HSScrollMenu: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
       
        let width = self.frame.width
        
        for i in 0..<items!.count {
            
            let view = items?[i] as! UIView
            
            let offSizeX = fabs(width / 6.0 * CGFloat(2 * tag + 1) - width / 2.0 - scrollView.contentOffset.x)
            let offSizeY = sqrt(fabs(width * width / 4.0 - offSizeX * offSizeX))
            
            view.center = CGPoint(x: width / 6.0 * CGFloat(2 * tag + 1), y: width / 2.0 - offSizeY + width / 4.0)
            view.bounds = CGRect(x: 0.0, y: 0.0, width: (width / 2.0 - offSizeX) / (width / 2.0) * 40.0 + 20.0, height: (width / 2.0 - offSizeX) / (width / 2.0) * 40.0 + 20.0)
            
        }
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var location: Int = 0;
        let width = self.frame.width
        let y = scrollView.contentOffset.x / (width / 2.0)
        
        let x = Int(y * 10)
        
        if x % 10 >= 5 {
            location = x / 10 + 1;
        } else {
            location = x / 10
        }
        
        scrollView.setContentOffset(CGPoint(x: width / 3.0 * CGFloat(location), y: 0.0), animated: true)
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        var location: Int = 0;
        let width = self.frame.width
        let y = scrollView.contentOffset.x / (width / 2.0)
        
        let x = Int(y * 10)
        
        if x % 10 >= 5 {
            location = x / 10 + 1;
        } else {
            location = x / 10
        }
        
        scrollView.setContentOffset(CGPoint(x: width / 3.0 * CGFloat(location), y: 0.0), animated: true)
    }
    
}





