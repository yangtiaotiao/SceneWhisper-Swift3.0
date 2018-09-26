//
//  SWModifyPasswordViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/6/2.
//  Copyright © 2017年 weipo. All rights reserved.
//  修改密码

import UIKit
import SVProgressHUD

class SWModifyPasswordViewController: UIViewController {

    
    @IBOutlet weak var passwordTextField: UITextField! //密码输入textField
    
    @IBOutlet weak var newPasswordTextField: UITextField! //新密码输入textField
    
    @IBOutlet weak var comfirmPwdTextField: UITextField! //确认密码输入textField
    
    @IBOutlet weak var passwordCheckButton: UIButton! //查看密码按钮
    
    @IBOutlet weak var newPasswordCheckButton: UIButton! //新密码查看按钮
    
    var isCheckedPassword: Bool = false //查看密码的状态
    var isCheckedNewPassword: Bool = false //查看新密码的状态
    
    //初始化viewController
    class func initViewController() -> SWModifyPasswordViewController {
        return UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SWModifyPasswordViewController") as! SWModifyPasswordViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        

    }
    
    //页面返回事件处理
    @IBAction func getbackButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //确认按钮事件处理
    @IBAction func comfirmButtonClicked(_ sender: Any) {
    
        //验证输入
        if (passwordTextField.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "旧密码不能为空!")
            return
        }
        if (newPasswordTextField.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "新密码不能为空!")
            return
        }
        if (comfirmPwdTextField.text?.isEmpty)! {
            SVProgressHUD.showError(withStatus: "确认密码不能为空!")
            return
        }
        if (comfirmPwdTextField.text != newPasswordTextField.text) {
            SVProgressHUD.showError(withStatus: "确认密码与新密码不一致!")
            return
        }
        
        // 修改请求
        let parameters = ["userId": SWDataManager.currentUserId(),
                          "oldPassword": self.passwordTextField.text!,
                          "newPassword": self.comfirmPwdTextField.text!]
        SWRequestManager.updatePassword(parameters,
                                  responseCompletion: { [weak self] (data, error) in
                                    guard let strongSelf = self else { return }
                                    strongSelf.updatePasswordHandler(data, error: error)
        })
        
    }
    //修改密码请求结果处理
    func updatePasswordHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
        
        if error == nil {
            SVProgressHUD.showSuccess(withStatus: "修改密码成功")
        } else {
            SVProgressHUD.showError(withStatus: error?.errorMessage)
        }
        
    }
    //查看密码按钮事件处理
    @IBAction func passwordCheckButtonClicked(_ sender: Any) {
        
        if isCheckedPassword {
            isCheckedPassword = false
            passwordCheckButton.setImage(UIImage(named:"xg眼睛闭"), for: UIControlState.normal)
            passwordTextField.isSecureTextEntry = true
        } else {
            isCheckedPassword = true
            passwordCheckButton.setImage(UIImage(named:"xg眼睛"), for: UIControlState.normal)
            passwordTextField.isSecureTextEntry = false
        }
    }
    
    //查看新密码按钮事件处理
    @IBAction func newPasswordCheckButtonClicked(_ sender: Any) {
        
        if isCheckedNewPassword {
            isCheckedNewPassword = false
            newPasswordCheckButton.setImage(UIImage(named:"xg眼睛闭"), for: UIControlState.normal)
            newPasswordTextField.isSecureTextEntry = true
            comfirmPwdTextField.isSecureTextEntry = true
        } else {
            isCheckedNewPassword = true
            newPasswordCheckButton.setImage(UIImage(named:"xg眼睛"), for: UIControlState.normal)
            newPasswordTextField.isSecureTextEntry = false
            comfirmPwdTextField.isSecureTextEntry = false
        }
    }
    
}





