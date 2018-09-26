//
//  SWRequestManager.swift
//  SceneWhisper
//
//  Created by weipo on 2017/5/19.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import Alamofire

//测试
//private let SWUrlHeader = "http://scenechat.ngrok.cc/secretmessage/"
//正式
//private let SWUrlHeader = "http://www.shengzhe.org/scenechat/"
//测试
//private let SWUrlHeader = "http://scenechat.free.ngrok.cc/secretmessage/"
//测试
//private let SWUrlHeaderts = "http://119.23.226.0:8080/scenechat/"

class SWRequestManager {


    typealias responseCompletion = ((HSSuccessResponse?, HSErrorResponse?) -> Void)?
    
    //发现信息
    class func discoveryMessage(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/m/queryDiscoveryMessage"
        let method: HTTPMethod = .get
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }

    }
    
    
    //查询私语详细信息
    class func queryMessageDetail(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/m/queryMessageDetail"
        let method: HTTPMethod = .get
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    
    //增加私语信息
    class func addMessage(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/m/addMessage"
        let method: HTTPMethod = .post
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    //查询用户私语信息库
    class func queryUserMessage(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/m/queryUserMessage"
        let method: HTTPMethod = .get
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    //查询密信片信息
    class func queryMessageCard(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/m/queryMessageCard"
        let method: HTTPMethod = .get
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    //用户登录
    class func login(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/u/login"
        let method: HTTPMethod = .get
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    //向手机发送验证码
    class func getVerificationCode(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
    
        let url = SWUrlHeader + "m/u/sendPhoneVCode"
        let method: HTTPMethod = .post
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
    }
    
    //注册用户信息
    class func register(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/u/register"
        let method: HTTPMethod = .post
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    
    //第三方平台账号登录
    class func thirdPlatformLogin(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/u/thirdPlatformLogin"
        let method: HTTPMethod = .post
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    //更新用户信息
    class func updateUserInfo(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/u/updateUserInfo"
        let method: HTTPMethod = .post
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    //更新用户密码
    class func updatePassword(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/u/updatePassword"
        let method: HTTPMethod = .post
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    //更新手机号码
    class func updatePhone(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/u/updatePhone"
        let method: HTTPMethod = .post
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
    
    //联系我们
    class func concactUs(_ parameters: Dictionary<String, Any>, responseCompletion: responseCompletion) {
        
        let url = SWUrlHeader + "m/u/concactUs"
        let method: HTTPMethod = .post
        
        HSRequest.request(url, method: method, parameters: parameters, success: { (data) in
            responseCompletion!(data, nil)
        }) { (error) in
            responseCompletion!(nil, error)
        }
        
    }
}










