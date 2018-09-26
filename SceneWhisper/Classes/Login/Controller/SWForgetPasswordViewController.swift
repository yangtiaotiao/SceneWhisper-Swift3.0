//
//  SWForgetPasswordViewController.swift
//  SceneWhisper
//
//  Created by weipo 2017/7/28.
//  Copyright © 2017年 weipo. All rights reserved.
//  找回密码

import UIKit
import SVProgressHUD
//import HSSwiftExtensions

class SWForgetPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var phoneTextField: UITextField! //手机号输入textField
    @IBOutlet weak var verifyCodeTextField: UITextField! //验证码输入textField
    @IBOutlet weak var verifyCodeButton: UIButton! //验证码获取按钮
    
    var timer: Timer? //计时器
    var seconds: Int = 60 //读秒数

    //初始化viewController
    class func initViewController() -> SWForgetPasswordViewController {
        return UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SWForgetPasswordViewController") as! SWForgetPasswordViewController
    }

    //销毁前的处理
    deinit {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
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
        
        //页面消失时停止读秒
        if timer != nil {
            timer?.fireDate = Date.distantFuture
        }
    }
    
    //页面返回事件处理
    @IBAction func getbackButtonClicked(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) { 
            
        }
    }
    
    //验证码获取按钮事件处理
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
                    //忘记密码处理
                    
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
    
    //提交验证码
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        let viewController = SWResetPasswordViewController.initViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }

    //计时器读秒事件
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






