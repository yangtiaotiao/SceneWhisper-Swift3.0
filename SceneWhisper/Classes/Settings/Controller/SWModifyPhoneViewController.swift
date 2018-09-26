//
//  SWModifyPhoneViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/6/2.
//  Copyright © 2017年 weipo. All rights reserved.
//  修改用户手机号

import UIKit
import SVProgressHUD
import HSSwiftExtensions

class SWModifyPhoneViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField! //密码输入textField
    
    @IBOutlet weak var phoneTextField: UITextField! //手机号输入textField
    
    @IBOutlet weak var verifyCodeTextField: UITextField! //验证码输入textField
    
    @IBOutlet weak var verifyCodeButton: UIButton! //获取验证码按钮
    
    var timer: Timer? //计时器
    var seconds: Int = 60 //读秒数

    //页面销毁前的处理
    deinit {
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
    }
    
    //初始化viewController
    class func initViewController() -> SWModifyPhoneViewController {
        return UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SWModifyPhoneViewController") as! SWModifyPhoneViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //初始化计时器
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(verifySecondsAction), userInfo: nil, repeats: true)
        timer?.fireDate = Date.distantFuture
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //停止读秒
        if timer != nil {
            timer?.fireDate = Date.distantFuture
        }
    }
    
    //页面返回事件处理
    @IBAction func getbackButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //获取验证码按钮事件处理
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
                
                if error == nil {
                    
                } else {
                    guard let strongSelf = self else { return }
                    strongSelf.seconds = 0
                    print("get verification code failure: \(String(describing: error))")
                    SVProgressHUD.showError(withStatus: "发送验证码失败")
                }
            }
            
        } else {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号！")
        }
        
    }

    //确定按钮事件处理
    @IBAction func comfirmButtonClicked(_ sender: Any) {
        
        let phoneNumber = self.phoneTextField.text!
        let password = self.passwordTextField.text!
        let verifyCode = self.verifyCodeTextField.text!
        
        if password.isEmpty {
            SVProgressHUD.showError(withStatus: "登录密码不能为空！")
            return
        }
        
        if phoneNumber.isEmpty {
            SVProgressHUD.showError(withStatus: "手机号不能为空！")
            return
        }
        
        if verifyCode.isEmpty {
            SVProgressHUD.showError(withStatus: "验证码不能为空！")
            return
        }
        
        SMSSDK.commitVerificationCode(verifyCode,
                                      phoneNumber: phoneNumber,
                                      zone: "+86",
                                      result: {[weak self] (error) in
                                        guard let strongSelf = self else { return }
                                        strongSelf.commitVerificationCodeHandler(error)
        })
    }
    //提交验证码事件处理
    func commitVerificationCodeHandler(_ error: Error?) {
        
        if error == nil {
            let parameters = ["userId": SWDataManager.currentUserId(),
                              "password": self.passwordTextField.text!,
                              "phone": self.phoneTextField.text! ]
            SWRequestManager.updatePhone(parameters,
                                      responseCompletion: { [weak self] (data, error) in
                                        guard let strongSelf = self else { return }
                                        strongSelf.updatePhoneHandler(data, error: error)
            })
            
        } else {
            
            print("get verification code failure: \(String(describing: error))")
            SVProgressHUD.showError(withStatus: "验证码验证失败！")
        }
    }
    //修改手机号请求结果处理
    func updatePhoneHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
        
        if error == nil {
            SVProgressHUD.showSuccess(withStatus: "绑定新手机号成功")
        } else {
            SVProgressHUD.showError(withStatus: error?.errorMessage)
        }
        
    }
    //验证码读秒事件处理
    func verifySecondsAction() {
        
        if seconds > 0 {
            seconds -= 1
            print(seconds.description)
            verifyCodeButton.setTitle(String(format: "%@秒后重试", arguments: [seconds.description]), for: .normal)
        } else {
            timer?.fireDate = Date.distantFuture
            verifyCodeButton.isEnabled = true
            verifyCodeButton.setTitle("获取验证码", for: .normal)
            seconds = 60
        }
        
    }
    
    
}




