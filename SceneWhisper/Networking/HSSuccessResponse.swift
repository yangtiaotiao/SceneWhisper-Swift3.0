//
//  HSSuccessResponse.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/6.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation


class HSSuccessResponse {

    public var code: String?
    
//    public var message: String?
    
    public var data: Any?
    
    public init(code: String, data: Any?) {
        
        self.code = code
//        self.message = message
        self.data = data
    
    }
    
}









