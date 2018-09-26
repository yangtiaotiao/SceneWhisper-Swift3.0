//
//  SWContactUsViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/6/23.
//  Copyright © 2017年 weipo. All rights reserved.
//  联系我们

import UIKit
import SVProgressHUD

class SWContactUsViewController: UIViewController {

    
    @IBOutlet weak var backgroundImageView: UIImageView! //背景图
    @IBOutlet weak var textBgView: UIView! //建议内容背景View
    @IBOutlet weak var suggestTextView: UITextView! //建议内容textView
    
    var isBeginEditing: Bool = false //是否开始编辑
    
    
    //初始化viewController
    class func initViewController() -> SWContactUsViewController {
        return UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SWContactUsViewController") as! SWContactUsViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()     
        //为建议内容textView的delegate赋值
        suggestTextView.delegate = self
        
        //设置textBgView
        textBgView.layer.cornerRadius = 5.0
        textBgView.layer.borderColor = UIColor.white.cgColor
        textBgView.layer.borderWidth = 1.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //页面返回事件处理
    @IBAction func getbackButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //提交按钮事件处理
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        
        if isBeginEditing && suggestTextView.text != "" {
            
            // 修改请求
            let parameters = ["userId": SWDataManager.currentUserId(),
                              "message": suggestTextView.text!]
            SWRequestManager.concactUs(parameters,
                                       responseCompletion: { [weak self] (data, error) in
                                        guard let strongSelf = self else { return }
                                        strongSelf.concactUsHandler(data, error: error)
            })
            
        } else {
            SVProgressHUD.showError(withStatus: "建议内容不能为空！")
        }
    }
    //修改密码请求结果处理
    func concactUsHandler(_ result: HSSuccessResponse?, error: HSErrorResponse?) {
        
        if error == nil {
            SVProgressHUD.showSuccess(withStatus: "发送成功")
        } else {
            SVProgressHUD.showError(withStatus: error?.errorMessage)
        }
        
    }
}


//MARK: UITextViewDelegate
extension SWContactUsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if isBeginEditing == false {
            suggestTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = "请写下您对我们的意见或者建议，我们会努力为您提供更好的服务..."
            isBeginEditing = false
        } else {
            isBeginEditing = true
        }
    }
}









