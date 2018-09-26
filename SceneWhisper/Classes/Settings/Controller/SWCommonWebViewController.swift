//
//  SWCommonWebViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/6/10.
//  Copyright © 2017年 weipo. All rights reserved.
//  关于我们->用户协议

import UIKit
import SVProgressHUD

class SWCommonWebViewController: UIViewController {
    
    
    @IBOutlet weak var swWebView: UIWebView!
    
    var commonRequest: URLRequest? //需要的跳转的请求
    
    //初始化viewController
    class func initViewController() -> SWCommonWebViewController {
        return UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SWCommonWebViewController") as! SWCommonWebViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //设置背景颜色
        swWebView.backgroundColor = .white
        
        //加载需要跳转的网络请求
        if commonRequest == nil {
            print("Common web view request is nil")
        } else {
            swWebView.loadRequest(commonRequest!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
}

//MARK: UIWebViewDelegate
extension SWCommonWebViewController: UIWebViewDelegate {

    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
        print("Common web view load failure, error:\(error)")
    }
    
    
}









