//
//  SWResetPasswordViewController.swift
//  SceneWhisper
//
//  Created by weipo 2017/7/28.
//  Copyright © 2017年 weipo. All rights reserved.
//  忘记密码->重置密码

import UIKit

class SWResetPasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordTextField: UITextField! //新密码输入textField
    
    @IBOutlet weak var confirmPwdTextField: UITextField! //密码确认输入textField
    
    @IBOutlet weak var newPasswordCheckButton: UIButton! //密码查看按钮
    
    var isCheckedNewPassword: Bool = false //密码查看状态
    
    //页面初始化
    class func initViewController() -> SWResetPasswordViewController {
        return UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SWResetPasswordViewController") as! SWResetPasswordViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //页面返回事件处理
    @IBAction func getbackButtonClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //密码查看按钮事件处理
    @IBAction func newPasswordCheckButtonClicked(_ sender: Any) {
        
        if isCheckedNewPassword {
            isCheckedNewPassword = false
            newPasswordCheckButton.setImage(UIImage(named:"xg眼睛闭"), for: UIControlState.normal)
            newPasswordTextField.isSecureTextEntry = true
            confirmPwdTextField.isSecureTextEntry = true
        } else {
            isCheckedNewPassword = true
            newPasswordCheckButton.setImage(UIImage(named:"xg眼睛"), for: UIControlState.normal)
            newPasswordTextField.isSecureTextEntry = false
            confirmPwdTextField.isSecureTextEntry = false
        }
        
    }
    
    //提交新密码
    @IBAction func confirmButtonClicked(_ sender: Any) {
     
        //添加提交新密码处理接口
        
        
        
    }
    
}










