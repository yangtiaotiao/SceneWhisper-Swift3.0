//
//  SWLoginViewController.swift
//  SceneWhisper
//
//  Created by weipo 2017/5/8.
//  Copyright © 2017年 weipo. All rights reserved.
//  登录

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD


class SWLoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginSwitch: HSCustomSwitch!  //登录和注册开关
    @IBOutlet weak var accountTextField: UITextField! //账号输入textField
    @IBOutlet weak var passwordTextField: UITextField! //密码输入textField
    
    @IBOutlet var qqButton: UIButton!
    @IBOutlet var wxButton: UIButton!
    @IBOutlet var wbButton: UIButton!
    //初始化viewController
    class func initViewController() -> SWLoginViewController {
        return UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SWLoginViewController") as! SWLoginViewController
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //登录注册开关delegate赋值
        self.loginSwitch.delegate = self
        
        //添加IQKeyboard键盘事件功能
        self.accountTextField.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(previousAction(_:)), nextAction: #selector(nextAction(_:)), doneAction: #selector(doneAction(_:)), shouldShowPlaceholder: true)
        self.accountTextField.keyboardToolbar.previousBarButton.isEnabled = false
        self.accountTextField.keyboardToolbar.nextBarButton.isEnabled = true
        
        self.passwordTextField.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(previousAction(_:)), nextAction: #selector(nextAction(_:)), doneAction: #selector(doneAction(_:)), shouldShowPlaceholder: true)
        self.passwordTextField.keyboardToolbar.previousBarButton.isEnabled = true
        self.passwordTextField.keyboardToolbar.nextBarButton.isEnabled = false
        
        // 判断是否安装第三软件
        wxButton.isHidden = UMSocialManager.default().isInstall(.wechatSession) ? false : true
        qqButton.isHidden = UMSocialManager.default().isInstall(.QQ) ? false : true
        wbButton.isHidden = UMSocialManager.default().isInstall(.sina) ? false : true
    }

    //QQ登录按钮处理
    @IBAction func qqLoginButtonClicked(_ sender: Any) {
        
        UMSocialSwiftInterface.auth(plattype: UMSocialPlatformType.QQ, viewController: self) { [weak self] (data, error) in
            guard let strongSelf = self else { return }
            strongSelf.umengAuthHandler(data, error, "2")
        }
        
    }
    
    //微信登录按钮处理
    @IBAction func wechatLoginButtonClicked(_ sender: Any) {
       
        UMSocialSwiftInterface.auth(plattype: UMSocialPlatformType.wechatSession, viewController: self) { [weak self] (data, error) in
            guard let strongSelf = self else { return }
            strongSelf.umengAuthHandler(data, error, "1")
        }
       
    }
    
    //微博登录按钮处理
    @IBAction func weiboLoginButtonClicked(_ sender: Any) {
        
        UMSocialSwiftInterface.auth(plattype: UMSocialPlatformType.sina, viewController: self) { [weak self] (data, error) in
            
            guard let strongSelf = self else { return }
            strongSelf.umengAuthHandler(data, error, "3")
            
        }
        
    }
    
    //忘记密码按钮处理
    @IBAction func forgetPwdButtonClicked(_ sender: Any) {
        
//        let viewController = SWForgetPasswordViewController.initViewController()
//        let navi = UINavigationController(rootViewController: viewController)
//        self.present(navi, animated: true) {
//            
//        }
    }
    
    //键盘事件上一个
    func previousAction(_ sender: UITextField) {
        if passwordTextField.isFirstResponder {
            accountTextField.becomeFirstResponder()
        }
    }
    
    //键盘事件下一个
    func nextAction(_ sender: UITextField) {
        if accountTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    //键盘事件完成
    func doneAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //登录Action
    func loginAction() {
        
        let account = self.accountTextField.text!
        let password = self.passwordTextField.text!
        
        if account.isEmpty {
            SVProgressHUD.showError(withStatus: "账号不能为空！")
            return
        }
        
        if password.isEmpty {
            SVProgressHUD.showError(withStatus: "密码不能为空！")
            return
        }
        
        let parameters = ["phone": account,
                          "password": password]
        SWRequestManager.login(parameters) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            strongSelf.accountLoginHandler(result, error: error)
        }
        
    }
    
    //账号登录请求处理
    func accountLoginHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
        
        //登录接口已关闭，方便测试，
//        let homeViewController = UINavigationController(rootViewController: SWHomeViewController.initViewController())
//        UIApplication.shared.keyWindow?.rootViewController = homeViewController
        
        //登录接口数据返回正式处理
        if error == nil {

            let userInfo = SWUserInfoModel(userInfo: result?.data as! Dictionary<String, Any>)
            SWDataManager.manager.saveUserInfo(userInfo)
            SWDataManager.saveCurrentUserId(userInfo.userID)
            SWDataManager.saveUserLoginStatus(true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                let homeViewController = UINavigationController(rootViewController: SWHomeViewController.initViewController())
                UIApplication.shared.keyWindow?.rootViewController = homeViewController
            })

        } else {
            SVProgressHUD.showError(withStatus: error?.errorMessage)
        }
    }
    
    //友盟授权处理
    func umengAuthHandler(_ data:Any?,_ error:Error?,_ platformType:String) {
        
        if error == nil {
            print("data: \(String(describing: data))")
            let tempData = data as! UMSocialAuthResponse
            
            UMSocialSwiftInterface.getUserInfo(plattype: tempData.platformType, viewController: self, completion: { [weak self] (userInfo, error) in
                guard let strongSelf = self else { return }
                strongSelf.umengGetUserInfoHandler(userInfo, error, platformType)
            })
            
        } else {
            print("error: \(String(describing: error))")
        }
    }
    
    //友盟获取用户信息处理
    func umengGetUserInfoHandler(_ data:Any?,_ error:Error?,_ platformType:String) {
        
        if error == nil {
            print("data: \(String(describing: data))")
            let tempData = data as! UMSocialUserInfoResponse
            var tempGender: Int = -1
            if tempData.unionGender! == "男" {
                tempGender = 0
            } else {
                tempGender = 1
            }
            let parameters: Dictionary<String, Any> = ["uid": tempData.uid!,
                                                       "platformId": platformType,
                                                       "account": "",
                                                       "photo": tempData.iconurl!,
                                                       "genders": tempGender,
                                                       "nickName": tempData.name!]
            
            SWRequestManager.thirdPlatformLogin(parameters,
                                                responseCompletion: { [weak self] (result, error) in
                                                    guard let strongSelf = self else {return}
                                                    strongSelf.thirdPlatformLoginHandler(result, error: error)
            })
            
        } else {
            print("error: \(String(describing: error))")
        }

    }
    
    //第三方平台登录请求处理
    func thirdPlatformLoginHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
        
        if error == nil {
            
            let userInfo = SWUserInfoModel(userInfo: result?.data as! Dictionary<String, Any>)
            SWDataManager.manager.saveUserInfo(userInfo)
            SWDataManager.saveCurrentUserId(userInfo.userID)
            SWDataManager.saveUserLoginStatus(true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                let homeViewController = UINavigationController(rootViewController: SWHomeViewController.initViewController())
                UIApplication.shared.keyWindow?.rootViewController = homeViewController
            })
            
        } else {
            SVProgressHUD.showError(withStatus: error?.errorMessage)
        }
        
    }
    
}

//SWLoginViewController 的 HSCustomSwitch Delegate扩展
extension SWLoginViewController: HSCustomSwitchDelegate {

    func switchAction(_ status: Bool) {
        print("status: \(status)")
        
        if status {
            
            let viewController = SWRegisteViewController.initViewController()
            viewController.modalTransitionStyle = .flipHorizontal
            viewController.delegate = self
            self.present(viewController, animated: true, completion: { 
                
            })
            
        } else {
            
            self.loginAction()
        }
    }
    
}

//SWLoginViewController 的 SWRegisteViewController Delegate扩展
extension SWLoginViewController: SWRegisteViewControllerDelegate {
    
    func getbackToLoginViewController() {
        self.loginSwitch.setupViewDirection(.left)
    }
    
}








