//
//  DateFormatterSingleton.swift
//  SwiftCustomExtensionDemo
//
//  Created by weipo on 2016/10/18.
//  Copyright © 2016年 weipo. All rights reserved.
//

import Foundation

@available(iOS 8.0, *)
class DateFormatterSingleton: DateFormatter {
    
    static let sharedInstance: DateFormatter = DateFormatter()
    //only use class. This prevents others from using the default '()' initializer for this class.
    fileprivate override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
