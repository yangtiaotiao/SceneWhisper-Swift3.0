//
//  SWUserInfoModel.swift
//  SceneWhisper
//
//  Created by weipo 2017/12/1.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

class SWUserInfoModel: NSObject {

    //参考接口文档返回数据
    var userID: String = ""
    var nickName: String = ""
    var phone: String = ""
    var genders: Int = 0 //0:男, 1:女, -1:没有性别
    var photo: String = ""
    var signatureUrl: String = ""
    
    override init() {
        super.init()
    }
    
    convenience init(userInfo: Dictionary<String, Any>) {
        self.init()
        
        if userInfo["id"] == nil || userInfo["id"] is NSNull {
            userID = ""
        } else {
            userID = String.init(format: "%@", arguments: [userInfo["id"] as! CVarArg])
        }
        
        if userInfo["nickName"] == nil || userInfo["nickName"] is NSNull {
            nickName = ""
        } else {
            nickName = userInfo["nickName"] as! String
        }
        
        if userInfo["phone"] == nil || userInfo["phone"] is NSNull {
            phone = ""
        } else {
            phone = userInfo["phone"] as! String
        }
        
        if userInfo["genders"] == nil || userInfo["genders"] is NSNull {
            genders = -1
        } else {
            genders = Int(String(format: "%@", arguments: [userInfo["genders"] as! CVarArg]))!
        }
        
        if userInfo["photo"] == nil || userInfo["photo"] is NSNull {
            photo = ""
        } else {
            photo = userInfo["photo"] as! String
        }
        
        if userInfo["signatureUrl"] == nil || userInfo["signatureUrl"] is NSNull {
            signatureUrl = ""
        } else {
            signatureUrl = userInfo["signatureUrl"] as! String
        }
        
        
    }
    
}


