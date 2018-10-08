//
//  SWMessageInfoModel.swift
//  SceneWhisper
//
//  Created by weipo 2017/12/26.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

class SWMessageInfoModel: NSObject {

    //参考接口文档返回的数据说明
    var messageId: NSInteger = 0
    var messageReadStartTime: String = ""
    var messageReadEndTime: String = ""
    var messageTitle: String = ""
    var messageAddTime: String = ""
    var messageReadTimes: Int = 0
    var messageReadedTimes: Int = 0
    var messageContent: String = ""
    var messageReadStartMonth: String = ""
    var messageReadEndMonth: String = ""
    var messageReadStartDay: String = ""
    var messageReadEndDay: String = ""
    var messageScope: Int = 0
    var messageReadUsers: Array<Dictionary<String,Any>> = [["userId": 0,
                                                            "userGender": -1,
                                                            "userPhoto": "",
                                                            "readTime": ""]]
    var placeName: String = ""
    var placeId: NSInteger = 0
    var placeLat: String = ""
    var placeLng: String = ""
    var areaName: String = ""
    var userId: NSInteger = 0
    var userPhoto: String = ""
    var userGender: Int = -1
    var userSignatureUrl: String = ""
    var attachmentTypeId: Int = 0
    var userNickName: String = ""
    var messageQrCodeUrl: String = ""
    var messageIsInCondition: Bool = false
    var attachments: Array<Dictionary<String,Any>> = [["attachmentId": "",
                      "attachmentUrl": "",
                      "attachmentLength": 0,
                      "attachmentThumbnailUrl": ""]]
    
//    var province: String = ""
//    var city: String = ""
//    var district: String = ""
//    var town: String = ""
//    var lng: String = ""
//    var lat: String = ""
//    var title: String = ""
//    var content: String = ""
    var keyId: Int = 0
    var scope: Int = 0
    var readStartMonth: String = ""
    var readEndMonth: String = ""
    var readStartDay: String = ""
    var readEndDay: String = ""
    var readStartTime: String = ""
    var readEndTime: String = ""
    var readTimes: Int = -1
//    var attachmentLength: Int = 0
//    var attachmentFile: String = ""
    
    override init() {
        super.init()
        
    }
    
    func discoveryMessageData(_ data: Dictionary<String, Any>) -> SWMessageInfoModel {
        
        let model = SWMessageInfoModel()
        
        
        if data["messageId"] == nil || data["messageId"] is NSNull {
            model.messageId = 0
        } else {
            model.messageId = Int(String(format: "%@", arguments: [data["messageId"] as! CVarArg]))!
        }
        
        if data["messageReadStartTime"] == nil || data["messageReadStartTime"] is NSNull {
            model.messageReadStartTime = ""
        } else {
            model.messageReadStartTime = data["messageReadStartTime"] as! String
        }
        
        if data["messageReadEndTime"] == nil || data["messageReadEndTime"] is NSNull {
            model.messageReadEndTime = ""
        } else {
            model.messageReadEndTime = data["messageReadEndTime"] as! String
        }
        
        if data["placeName"] == nil || data["placeName"] is NSNull {
            model.placeName = ""
        } else {
            model.placeName = data["placeName"] as! String
        }
        
        if data["placeId"] == nil || data["placeId"] is NSNull {
            model.placeId = 0
        } else {
            model.placeId = Int(String(format: "%@", arguments: [data["placeId"] as! CVarArg]))!
        }
        
        if data["messageAddTime"] == nil || data["messageAddTime"] is NSNull {
            model.messageAddTime = ""
        } else {
            model.messageAddTime = data["messageAddTime"] as! String
        }
        
        if data["placeLng"] == nil || data["placeLng"] is NSNull {
            model.placeLng = ""
        } else {
            model.placeLng = data["placeLng"] as! String
        }
        
        if data["placeLat"] == nil || data["placeLat"] is NSNull {
            model.placeLat = ""
        } else {
            model.placeLat = data["placeLat"] as! String
        }
        
        if data["userId"] == nil || data["userId"] is NSNull {
            model.userId = 0
        } else {
            model.userId = Int(String(format: "%@", arguments: [data["userId"] as! CVarArg]))!
        }
        
        if data["userPhoto"] == nil || data["userPhoto"] is NSNull {
            model.userPhoto = ""
        } else {
            model.userPhoto = data["userPhoto"] as! String
        }
        
        if data["userGenders"] == nil || data["userGenders"] is NSNull {
            model.userGender = -1
        } else {
            model.userGender = Int(String(format: "%@", arguments: [data["userGenders"] as! CVarArg]))!
        }
        
        if data["attachmentTypeId"] == nil || data["attachmentTypeId"] is NSNull {
            model.attachmentTypeId = 0
        } else {
            model.attachmentTypeId = Int(String(format: "%@", arguments: [data["attachmentTypeId"] as! CVarArg]))!
        }
        
        return model
    }
    
    // 读取密信
    func queryMessageDetail(_ data: Dictionary<String, Any>) -> SWMessageInfoModel {
        
        let model = SWMessageInfoModel()
        
        if data["messageId"] == nil || data["messageId"] is NSNull {
            model.messageId = 0
        } else {
            model.messageId = Int(String(format: "%@", arguments: [data["messageId"] as! CVarArg]))!
        }
        
        if data["messageTitle"] == nil || data["messageTitle"] is NSNull {
            model.messageTitle = ""
        } else {
            model.messageTitle = data["messageTitle"] as! String
        }
        
        if data["messageAddTime"] == nil || data["messageAddTime"] is NSNull {
            model.messageAddTime = ""
        } else {
            model.messageAddTime = data["messageAddTime"] as! String
        }
        
        if data["messageReadTimes"] == nil || data["messageReadTimes"] is NSNull {
            model.messageReadTimes = 0
        } else {
            model.messageReadTimes = Int(String(format: "%@", arguments: [data["messageReadTimes"] as! CVarArg]))!
        }
        
        if data["messageReadedTimes"] == nil || data["messageReadedTimes"] is NSNull {
            model.messageReadedTimes = 0
        } else {
            model.messageReadedTimes = Int(String(format: "%@", arguments: [data["messageReadedTimes"] as! CVarArg]))!
        }
        
        if data["messageContent"] == nil || data["messageContent"] is NSNull {
            model.messageContent = ""
        } else {
            model.messageContent = data["messageContent"] as! String
        }
        
        if data["placeId"] == nil || data["placeId"] is NSNull {
            model.placeId = 0
        } else {
            model.placeId = Int(String(format: "%@", arguments: [data["placeId"] as! CVarArg]))!
        }
        
        if data["placeName"] == nil || data["placeName"] is NSNull {
            model.placeName = ""
        } else {
            model.placeName = data["placeName"] as! String
        }
        
        if data["placeLng"] == nil || data["placeLng"] is NSNull {
            model.placeLng = ""
        } else {
            model.placeLng = data["placeLng"] as! String
        }
        
        if data["placeLat"] == nil || data["placeLat"] is NSNull {
            model.placeLat = ""
        } else {
            model.placeLat = data["placeLat"] as! String
        }
        
        if data["userId"] == nil || data["userId"] is NSNull {
            model.userId = 0
        } else {
            model.userId = Int(String(format: "%@", arguments: [data["userId"] as! CVarArg]))!
        }
        
        if data["userNickName"] == nil || data["userNickName"] is NSNull {
            model.userNickName = ""
        } else {
            model.userNickName = data["userNickName"] as! String
        }
        
        if data["userPhoto"] == nil || data["userPhoto"] is NSNull {
            model.userPhoto = ""
        } else {
            model.userPhoto = data["userPhoto"] as! String
        }
        
        if data["attachmentTypeId"] == nil || data["attachmentTypeId"] is NSNull {
            model.attachmentTypeId = 1
        } else {
            model.attachmentTypeId = Int(String(format: "%@", arguments: [data["attachmentTypeId"] as! CVarArg]))!
        }
        
        if data["attachments"] == nil || data["attachments"] is NSNull {
            model.attachments = []
        } else {
            model.attachments = data["attachments"] as! Array<Dictionary<String,Any>>
        }
        
        return model
        
    }
    //MARK:查询用户私语库
    func queryUserMessage(_ data: Dictionary<String, Any>) -> SWMessageInfoModel {
        
        let model = SWMessageInfoModel()
        
        if data["messageId"] == nil || data["messageId"] is NSNull {
            model.messageId = 0
        } else {
            model.messageId = Int(String(format: "%@", arguments: [data["messageId"] as! CVarArg]))!
        }
        
        if data["messageReadTimes"] == nil || data["messageReadTimes"] is NSNull {
            model.messageReadTimes = 0
        } else {
            model.messageReadTimes = Int(String(format: "%@", arguments: [data["messageReadTimes"] as! CVarArg]))!
        }
        
        if data["messageReadedTimes"] == nil || data["messageReadedTimes"] is NSNull {
            model.messageReadedTimes = 0
        } else {
            model.messageReadedTimes = Int(String(format: "%@", arguments: [data["messageReadedTimes"] as! CVarArg]))!
        }
        
        if data["messageTitle"] == nil || data["messageTitle"] is NSNull {
            model.messageTitle = ""
        } else {
            model.messageTitle = data["messageTitle"] as! String
        }
        
        if data["messageAddTime"] == nil || data["messageAddTime"] is NSNull {
            model.messageAddTime = ""
        } else {
            model.messageAddTime = data["messageAddTime"] as! String
        }
        
        model.messageReadStartMonth = "\(data["messageReadStartMonth"] ?? "")"
        model.messageReadEndMonth = "\(data["messageReadEndMonth"] ?? "")"
        model.messageReadStartDay = "\(data["messageReadStartDay"] ?? "")"
        model.messageReadEndDay = "\(data["messageReadEndDay"] ?? "")"
        model.messageReadStartTime = "\(data["messageReadStartTime"] ?? "")"
        model.messageReadEndTime = "\(data["messageReadEndTime"] ?? "")"
       
        if data["placeId"] == nil || data["placeId"] is NSNull {
            model.placeId = 0
        } else {
            model.placeId = Int(String(format: "%@", arguments: [data["placeId"] as! CVarArg]))!
        }
        
        if data["placeLng"] == nil || data["placeLng"] is NSNull {
            model.placeLng = ""
        } else {
            model.placeLng = data["placeLng"] as! String
        }
        
        if data["placeLat"] == nil || data["placeLat"] is NSNull {
            model.placeLat = ""
        } else {
            model.placeLat = data["placeLat"] as! String
        }
        
        if data["placeName"] == nil || data["placeName"] is NSNull {
            model.placeName = ""
        } else {
            model.placeName = data["placeName"] as! String
        }
        
        if data["areaName"] == nil || data["areaName"] is NSNull {
            model.areaName = ""
        } else {
            model.areaName = data["areaName"] as! String
        }
        
        if data["userId"] == nil || data["userId"] is NSNull {
            model.userId = 0
        } else {
            model.userId = Int(String(format: "%@", arguments: [data["userId"] as! CVarArg]))!
        }
        
        if data["userPhoto"] == nil || data["userPhoto"] is NSNull {
            model.userPhoto = ""
        } else {
            model.userPhoto = data["userPhoto"] as! String
        }
        
        if data["userGender"] == nil || data["userGender"] is NSNull {
            model.userGender = -1
        } else {
            model.userGender = Int(String(format: "%@", arguments: [data["userGender"] as! CVarArg]))!
        }
        
        if data["userNickName"] == nil || data["userNickName"] is NSNull {
            model.userNickName = ""
        } else {
            model.userNickName = data["userNickName"] as! String
        }
        
        return model
    }
 
    // MARK:查询密信片信息
    func queryMessageCard(_ data: Dictionary<String, Any>) -> SWMessageInfoModel {
        
        let model = SWMessageInfoModel()
        
        if data["messageId"] == nil || data["messageId"] is NSNull {
            model.messageId = 0
        } else {
            model.messageId = Int(String(format: "%@", arguments: [data["messageId"] as! CVarArg]))!
        }
        
        if data["messageReadTimes"] == nil || data["messageReadTimes"] is NSNull {
            model.messageReadTimes = 0
        } else {
            model.messageReadTimes = Int(String(format: "%@", arguments: [data["messageReadTimes"] as! CVarArg]))!
        }
        
        if data["messageReadedTimes"] == nil || data["messageReadedTimes"] is NSNull {
            model.messageReadedTimes = 0
        } else {
            model.messageReadedTimes = Int(String(format: "%@", arguments: [data["messageReadedTimes"] as! CVarArg]))!
        }
        
        if data["messageTitle"] == nil || data["messageTitle"] is NSNull {
            model.messageTitle = ""
        } else {
            model.messageTitle = data["messageTitle"] as! String
        }
        
        if data["messageAddTime"] == nil || data["messageAddTime"] is NSNull {
            model.messageAddTime = ""
        } else {
            model.messageAddTime = data["messageAddTime"] as! String
        }
        
        model.messageReadStartMonth = "\(data["messageReadStartMonth"] ?? "")"
        model.messageReadEndMonth = "\(data["messageReadEndMonth"] ?? "")"
        model.messageReadStartDay = "\(data["messageReadStartDay"] ?? "")"
        model.messageReadEndDay = "\(data["messageReadEndDay"] ?? "")"
        model.messageReadStartTime = "\(data["messageReadStartTime"] ?? "")"
        model.messageReadEndTime = "\(data["messageReadEndTime"] ?? "")"
        
        if data["messageQrCodeUrl"] == nil || data["messageQrCodeUrl"] is NSNull {
            model.messageQrCodeUrl = ""
        } else {
            model.messageQrCodeUrl = data["messageQrCodeUrl"] as! String
        }
        
        if data["messageIsInCondition"] == nil || data["messageIsInCondition"] is NSNull {
            model.messageIsInCondition = false
        } else {
            model.messageIsInCondition = (data["messageIsInCondition"] != nil)
        }
        
        if data["placeId"] == nil || data["placeId"] is NSNull {
            model.placeId = 0
        } else {
            model.placeId = Int(String(format: "%@", arguments: [data["placeId"] as! CVarArg]))!
        }
        
        if data["placeLng"] == nil || data["placeLng"] is NSNull {
            model.placeLng = ""
        } else {
            model.placeLng = data["placeLng"] as! String
        }
        
        if data["placeLat"] == nil || data["placeLat"] is NSNull {
            model.placeLat = ""
        } else {
            model.placeLat = data["placeLat"] as! String
        }
        
        if data["placeName"] == nil || data["placeName"] is NSNull {
            model.placeName = ""
        } else {
            model.placeName = data["placeName"] as! String
        }
        
        if data["areaName"] == nil || data["areaName"] is NSNull {
            model.areaName = ""
        } else {
            model.areaName = data["areaName"] as! String
        }
        
        if data["userId"] == nil || data["userId"] is NSNull {
            model.userId = 0
        } else {
            model.userId = Int(String(format: "%@", arguments: [data["userId"] as! CVarArg]))!
        }
        
        if data["userPhoto"] == nil || data["userPhoto"] is NSNull {
            model.userPhoto = ""
        } else {
            model.userPhoto = data["userPhoto"] as! String
        }
        
        if data["userGender"] == nil || data["userGender"] is NSNull {
            model.userGender = -1
        } else {
            model.userGender = Int(String(format: "%@", arguments: [data["userGender"] as! CVarArg]))!
        }
        
        if data["userNickName"] == nil || data["userNickName"] is NSNull {
            model.userNickName = ""
        } else {
            model.userNickName = data["userNickName"] as! String
        }
        
        if data["userSignatureUrl"] == nil || data["userSignatureUrl"] is NSNull {
            model.userSignatureUrl = ""
        } else {
            model.userSignatureUrl = data["userSignatureUrl"] as! String
        }
        
        if data["messageScope"] == nil || data["messageScope"] is NSNull {
            model.messageScope = 0
        } else {
            model.messageScope = Int(String(format: "%@", arguments: [data["messageScope"] as! CVarArg]))!
        }
        
        if data["messageReadUsers"] == nil || data["messageReadUsers"] is NSNull {
            model.messageReadUsers = []
        } else {
            model.messageReadUsers = data["messageReadUsers"] as! Array<Dictionary<String,Any>>
        }
        
        return model
    }
    // MARK:新增密语
    func addMessage(_ data: Dictionary<String, Any>) -> SWMessageInfoModel {
        let model = SWMessageInfoModel()
 
        model.readStartMonth = "\(data["readStartMonth"] ?? "")"
        model.readEndMonth = "\(data["readEndMonth"] ?? "")"
        model.readStartDay = "\(data["readStartDay"] ?? "")"
        model.readEndDay = "\(data["readEndDay"] ?? "")"
        model.readStartTime = "\(data["readStartTime"] ?? "")"
        model.readEndTime = "\(data["readEndTime"] ?? "")"
    
        if data["readTimes"] == nil || data["readTimes"] is NSNull {
            model.readTimes = -1
        } else {
            model.readTimes = data["readTimes"] as! Int
        }
        if data["scope"] == nil || data["scope"] is NSNull {
            model.scope = 0
        } else {
            model.scope = data["scope"] as! Int
        }
        if data["keyId"] == nil || data["keyId"] is NSNull {
            model.keyId = 0
        } else {
            model.keyId = data["keyId"] as! Int
        }
        
        return model
    }
}

