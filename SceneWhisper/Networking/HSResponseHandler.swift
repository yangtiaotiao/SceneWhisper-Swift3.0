//
//  HSResponseHandler.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/6.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import Alamofire

class HSResponseHandler {

    var data: HSSuccessResponse?
    var error: HSErrorResponse?
    
    
    class func handle(response: DataResponse<Any>?) -> HSResponseHandler {
        
        let handler = HSResponseHandler()
        if response?.value == nil {
            handler.error = HSErrorResponse(code: "-400000", message: "没有数据返回！")
            return handler
            
        }
        
        if (response?.value as! Dictionary<String, Any>)["result"] is NSNull {
            
            handler.error = HSErrorResponse(code: "-400000", message: "没有数据返回！")
            
        } else {
            
            let result: Dictionary<String, Any> = (response?.value as! Dictionary<String, Any>)
            let resultCode = String.init(format: "%@", result["code"] as! CVarArg)
            let resultMessage = result["msg"] 
            let data = result["content"]
            
            
            if resultCode == "1" {
                handler.data = HSSuccessResponse(code: resultCode, data: data)
            } else {
                handler.error = HSErrorResponse(code: resultCode, message: resultMessage as? String)
            }
            
        }
        
        return handler
        
    }

}
