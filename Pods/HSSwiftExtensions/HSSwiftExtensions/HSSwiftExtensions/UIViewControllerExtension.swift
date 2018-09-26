//
//  UIViewControllerExtension.swift
//  HSSwiftExtensions
//
//  Created by weipo 2017/2/14.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation


public extension UIViewController {

    public func topmostViewController() -> UIViewController {
    
        var viewController: UIViewController? = nil
        
        var window = UIApplication.shared.keyWindow
        
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.shared.windows
            for tempWindow in windows {
                if tempWindow.windowLevel == UIWindowLevelNormal {
                    window = tempWindow
                    break
                }
            }
        }
        
        let frontView = window?.subviews.first
        let nextResponder = frontView?.next
        
        if (nextResponder?.isKind(of: UIViewController.classForCoder()))! {
            viewController = nextResponder as? UIViewController
        } else {
            viewController = window?.rootViewController
        }
        
        return viewController!
    }
    

}
