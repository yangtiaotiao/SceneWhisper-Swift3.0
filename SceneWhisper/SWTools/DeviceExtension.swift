//
//  DeviceExtension.swift
//  SceneWhisper
//
//  Created by weipo 2017/7/28.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    class func isGreaterThanSystemVersion(_ version: Int) -> Bool {
        
        var result = false
        
        let mainVersion = UIDevice.current.systemVersion.components(separatedBy: ".").first
        
        if Int(mainVersion!)! > version {
            result = true
        }
        
        return result
    }
    
    
}
