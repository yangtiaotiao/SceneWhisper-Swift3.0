//
//  CALayerExtension.swift
//  SceneWhisper
//
//  Created by Yang on 2018/6/8.
//  Copyright © 2018年 weipo. All rights reserved.
//  xib\sb 添加设置边框颜色属性


import UIKit

extension CALayer {
    var borderColorWithColor : UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        get {
            return self.borderColorWithColor
        }
    }
    
}
