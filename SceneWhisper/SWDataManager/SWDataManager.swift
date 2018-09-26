//
//  SWDataManager.swift
//  SceneWhisper
//
//  Created by weipo 2017/9/29.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit
import FMDB


fileprivate let SWUserInfoKey = "SWLocalUserInformation_Key"
fileprivate let SWCurrentUserIDKey = "SWCurrentUserID_Key"
fileprivate let SWCurrentTokenKey = "SWCurrentToken_Key"
fileprivate let UserInformationTable = "t_UserInformation"

class SWDataManager: NSObject {

    var userInfoDB: FMDatabase?
    
    static let manager: SWDataManager = {
        return SWDataManager()
    }()
    
    override init() {
        super.init()
        self.userInfoDB = FMDatabase(path: SWDataManager.userInfoDatabasePath())
        
    }
    
    //缓存沙盒的文件夹路径
    class func SWDataFolder() -> String {
        let SWDataPath = NSHomeDirectory() + "/Documents/SWData"
        var directory: ObjCBool = ObjCBool(false)
        let exists = FileManager.default.fileExists(atPath: SWDataPath, isDirectory: &directory)
        
        if exists && directory.boolValue {
            
        } else {
            try! FileManager.default.createDirectory(atPath: SWDataPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        return SWDataPath
    }
    
    //用户信息db的路径
    class func userInfoDatabasePath() -> String {
        return SWDataManager.SWDataFolder() + "/userInfo.db"
    }
    
    //获取用户的登录状态
    class func checkUserLoginStatus() -> Bool {
        
        var result = false
        
        let userInfo = UserDefaults.standard.object(forKey: SWUserInfoKey)
        if userInfo == nil {
            let dic = ["loginStatus": false]
            UserDefaults.standard.set(dic, forKey: SWUserInfoKey)
        } else {
            let loginStatus = (userInfo as! Dictionary<String, Any>)["loginStatus"]
            if loginStatus == nil {
                let dic = ["loginStatus": false]
                UserDefaults.standard.set(dic, forKey: SWUserInfoKey)
            } else {
                result = (loginStatus as! NSNumber).boolValue
            }
        }
        return result
    }
    
    //保存用户的登录状态
    class func saveUserLoginStatus(_ status: Bool) {
        
        let dic = ["loginStatus": status]
        UserDefaults.standard.set(dic, forKey: SWUserInfoKey)
        
    }
    
    //保存当前用户的ID
    class func saveCurrentUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: SWCurrentUserIDKey)
    }
    
    //获取当前用户的ID
    class func currentUserId() -> String {
        let userid = UserDefaults.standard.string(forKey: SWCurrentUserIDKey)
        if userid == nil {
            return ""
        }
        return userid!
    }
    
    //保存当前的token
    class func saveCurrentToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: SWCurrentTokenKey)
    }
    
    //获取当前的token
    class func currentToken() -> String {
        let token = UserDefaults.standard.string(forKey: SWCurrentTokenKey)
        if token == nil {
            return ""
        }
        return token!
    }
    
    //保存用户信息
    func saveUserInfo(_ userInfo: SWUserInfoModel) {
        
        let userDefault = UserDefaults.standard
        userDefault.set(userInfo.userID, forKey: "userID")
        userDefault.set(userInfo.nickName, forKey: "nickName")
        userDefault.set(userInfo.photo, forKey: "photo")
        userDefault.set(userInfo.phone, forKey: "phone")
        userDefault.set(userInfo.genders, forKey: "genders")
        userDefault.set(userInfo.signatureUrl, forKey: "signatureUrl")
        
        //                userInfo.userID = results.string(forColumn: "userID")!
        //                userInfo.nickName = results.string(forColumn: "nickName")!
        //                userInfo.photo = results.string(forColumn: "photo")!
        //                userInfo.phone = results.string(forColumn: "phone")!
        //                userInfo.genders = Int(results.int(forColumn: "genders"))
        //                userInfo.signatureUrl = results.string(forColumn: "signatureUrl")!
//        if userInfoDB!.open() {
//
//            if !userInfoDB!.tableExists(UserInformationTable) {
//                let sql = "create table if not exists \(UserInformationTable) (id integer primary key, userID text, nickName text, phone text, genders integer, photo text, signatureUrl text)"
//                userInfoDB!.beginTransaction()
//                userInfoDB!.executeUpdate(sql, withArgumentsIn: [])
//                userInfoDB!.commit()
//            }
//
//            let results: FMResultSet = userInfoDB!.executeQuery("select * from \(UserInformationTable)", withArgumentsIn: [])!
//
//            if results.next() {
//                let sql = "update \(UserInformationTable) set nikeName = ?, phone = ?, genders = ?, photo = ?, signatureUrl = ? where userID = ?"
//                let arguments: [Any] = [userInfo.nickName, userInfo.phone, NSNumber(value: userInfo.genders), userInfo.photo, userInfo.signatureUrl, userInfo.userID]
//                userInfoDB! .beginTransaction()
//                userInfoDB!.executeUpdate(sql, withArgumentsIn: arguments)
//                userInfoDB!.commit()
//            } else {
//                let sql = "insert into \(UserInformationTable) (nikeName, phone, genders, photo, signatureUrl, userID) values (?, ?, ?, ?, ?, ?)"
//                let arguments: [Any] = [userInfo.nickName, userInfo.phone, NSNumber(value: userInfo.genders), userInfo.photo, userInfo.signatureUrl, userInfo.userID]
//                userInfoDB! .beginTransaction()
//                userInfoDB!.executeUpdate(sql, withArgumentsIn: arguments)
//                userInfoDB!.commit()
//            }
//
//            userInfoDB!.close()
//
//        }
    }
    
    //获取当前用户信息
    func currentUserInfo() -> SWUserInfoModel {
        
        let userInfo = SWUserInfoModel()
        let userDefault = UserDefaults.standard
        userInfo.userID =  userDefault.value(forKey: "userID") as! String
        userInfo.nickName = userDefault.value(forKey: "nickName") as! String
        userInfo.photo =  userDefault.value(forKey: "photo") as! String
        userInfo.phone = userDefault.value(forKey: "phone") as! String
        userInfo.genders =  userDefault.value(forKey: "genders") as! Int
        userInfo.signatureUrl = userDefault.value(forKey: "signatureUrl") as! String
        
        return userInfo
//
//        let userInfo = SWUserInfoModel()
//
//        if userInfoDB!.open() {
//
//            let results: FMResultSet = userInfoDB!.executeQuery("select * from \(UserInformationTable)", withArgumentsIn: [])!
//
//            if results.next() {
//                userInfo.userID = results.string(forColumn: "userID")!
//                userInfo.nickName = results.string(forColumn: "nickName")!
//                userInfo.photo = results.string(forColumn: "photo")!
//                userInfo.phone = results.string(forColumn: "phone")!
//                userInfo.genders = Int(results.int(forColumn: "genders"))
//                userInfo.signatureUrl = results.string(forColumn: "signatureUrl")!
//            }
//
//            userInfoDB!.close()
//        }
//
//        return userInfo
//    }
        
    }
}
