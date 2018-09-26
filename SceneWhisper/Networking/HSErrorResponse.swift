//
//  HSErrorResponse.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/6.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation


class HSErrorResponse {
    
    public var errorCode: String?
    
    public var errorMessage: String?
    
    public init(code: String?, message: String?) {
        
        self.errorCode = code
        self.errorMessage = message
        
    }

}
