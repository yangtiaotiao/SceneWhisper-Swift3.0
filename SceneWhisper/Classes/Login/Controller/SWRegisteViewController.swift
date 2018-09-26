//
//  SWRegisteViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/6/1.
//  Copyright © 2017年 weipo. All rights reserved.
//  注册页

import UIKit
import SVProgressHUD
//import HSSwiftExtensions

@objc protocol SWRegisteViewControllerDelegate: NSObjectProtocol {
    
    //注册成功后跳转到登录界面
    @objc optional func getbackToLoginViewController()
    
}

class SWRegisteViewController: UIViewController {

    @IBOutlet weak var registeSwitch: HSCustomSwitch! //注册开关控件
    @IBOutlet weak var verifyCodeButton: UIButton! //获取验证码按钮
    @IBOutlet weak var phoneTextField: UITextField! //手机号输入textField
    @IBOutlet weak var verifyCodeTextField: UITextField! //验证码输入textField
    @IBOutlet weak var passwordTextField: UITextField! //密码输入textField
    
    weak var delegate: SWRegisteViewControllerDelegate? //注册viewController的delegate
    
    var timer: Timer? //计时器
    var seconds: Int = 60 //读秒数
    
    //初始化viewController
    class func initViewController() -> SWRegisteViewController {
        return UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SWRegisteViewController") as! SWRegisteViewController
    }
    
    //销毁前的处理
    deinit {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        self.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //设置注册开关的delegate和样式
        self.registeSwitch.delegate = self
        self.registeSwitch.setupViewDirection(.right)
        
        //设置键盘事件
        self.phoneTextField.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(previousAction(_:)), nextAction: #selector(nextAction(_:)), doneAction: #selector(doneAction(_:)), shouldShowPlaceholder: true)
        self.phoneTextField.keyboardToolbar.previousBarButton.isEnabled = false
        self.phoneTextField.keyboardToolbar.nextBarButton.isEnabled = true
        
        self.verifyCodeTextField.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(previousAction(_:)), nextAction: #selector(nextAction(_:)), doneAction: #selector(doneAction(_:)), shouldShowPlaceholder: true)
        self.verifyCodeTextField.keyboardToolbar.previousBarButton.isEnabled = true
        self.verifyCodeTextField.keyboardToolbar.nextBarButton.isEnabled = true
        
        self.passwordTextField.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(previousAction(_:)), nextAction: #selector(nextAction(_:)), doneAction: #selector(doneAction(_:)), shouldShowPlaceholder: true)
        self.passwordTextField.keyboardToolbar.previousBarButton.isEnabled = true
        self.passwordTextField.keyboardToolbar.nextBarButton.isEnabled = false
        
        //初始化计时器
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(verifySecondsAction), userInfo: nil, repeats: true)
        timer?.fireDate = Date.distantFuture
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if timer != nil {
            timer?.fireDate = Date.distantFuture
        }
        
    }

    //键盘上一个输入的事件处理
    func previousAction(_ sender: UITextField) {
        if verifyCodeTextField.isFirstResponder {
            phoneTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            verifyCodeTextField.becomeFirstResponder()
        }
    }
    
    //键盘下一个输入的事件处理
    func nextAction(_ sender: UITextField) {
        if phoneTextField.isFirstResponder {
            verifyCodeTextField.becomeFirstResponder()
        } else if verifyCodeTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        }
    }
    
    //键盘完成的事件处理
    func doneAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    //验证码计时器事件处理
    func verifySecondsAction() {
        
        if seconds > 0 {
            seconds -= 1
            verifyCodeButton.setTitle(String(format: "%@秒后重试", arguments: [seconds.description]), for: .normal)
        } else {
            timer?.fireDate = Date.distantFuture
            verifyCodeButton.isEnabled = true
            verifyCodeButton.setTitle("获取验证码", for: .normal)
            seconds = 60
        }
        
    }
    
    //获取验证按钮事件处理
    @IBAction func verifyCodeButtonClicked(_ sender: Any) {
        
        let phoneNumber = self.phoneTextField.text!
        
        if phoneNumber.isEmpty {
            SVProgressHUD.showError(withStatus: "手机号不能为空！")
            return
        }
        
        if phoneNumber.isMobilePhone() {
            
            timer?.fireDate = Date.distantPast
            verifyCodeButton.isEnabled = false
            
            
            SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS,
                                       phoneNumber: phoneNumber,
                                       zone: "86")
            { [weak self] (error) in
                guard let strongSelf = self else { return }
                strongSelf.getVerifyCodeHandler(error)
            }
            
        } else {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号！")
        }

        
    }
    
    //验证码请求结果处理
    func getVerifyCodeHandler(_ error: Error?) {
        
        if error == nil {
            
        } else {
            self.seconds = 0
            print("get verification code failure: \(String(describing: error))")
            SVProgressHUD.showError(withStatus: "发送验证码失败")
        }
    }
    
    //提交验证码事件处理
    func commitVerificationCodeHandler(_ error: Error?) {
        
        if error == nil {
            let parameters = ["phone": self.phoneTextField.text!,
                              "password": self.passwordTextField.text!,
                              "code": "",
                              "time": "",
                              "vCode": ""]
            SWRequestManager.register(parameters,
                                      responseCompletion: { [weak self] (data, error) in
                                        guard let strongSelf = self else { return }
                                        strongSelf.registerHandler(data, error: error)
            })
            
        } else {
            
            print("get verification code failure: \(String(describing: error))")
            SVProgressHUD.showError(withStatus: "验证码验证失败！")
        }
    }
    
    //注册请求结果处理
    func registerHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
        
        if error == nil {
            let userInfo = SWUserInfoModel(userInfo: result?.data as! Dictionary<String, Any>)
            SWDataManager.manager.saveUserInfo(userInfo)
            SWDataManager.saveCurrentUserId(userInfo.userID)
            self.dismiss(animated: true, completion: nil)
        } else {
            SVProgressHUD.showError(withStatus: error?.errorMessage)
        }
        
    }
    
}


//注册开关的扩展
extension SWRegisteViewController: HSCustomSwitchDelegate {

    func switchAction(_ status: Bool) {
        
        if status {
            
            let phoneNumber = self.phoneTextField.text!
            let password = self.passwordTextField.text!
            let verifyCode = self.verifyCodeTextField.text!
            
            if phoneNumber.isEmpty {
                SVProgressHUD.showError(withStatus: "手机号不能为空！")
                return
            }
            
            if verifyCode.isEmpty {
                SVProgressHUD.showError(withStatus: "验证码不能为空！")
                return
            }
            
            if password.isEmpty {
                SVProgressHUD.showError(withStatus: "密码不能为空！")
                return
            }
            
            SMSSDK.commitVerificationCode(verifyCode,
                                          phoneNumber: phoneNumber,
                                          zone: "+86",
                                          result: {[weak self] (error) in
                                            guard let strongSelf = self else { return }
                                            strongSelf.commitVerificationCodeHandler(error)
            })
            
        } else {
            if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate?.getbackToLoginViewController)) {
                self.delegate!.getbackToLoginViewController!()
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}


















