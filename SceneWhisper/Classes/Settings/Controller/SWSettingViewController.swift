//
//  SWSettingViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/5/22.
//  Copyright © 2017年 weipo. All rights reserved.
//  用户设置页

import UIKit

class SWSettingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var dataResource: Array<Array<Dictionary<String, Any>>>? //tableView的dataResource
    
    //初始化viewController
    class func initViewController() -> SWSettingViewController {
        return UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SWSettingViewController") as! SWSettingViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //tableView的dataResource
        self.dataResource = [[["icon": "sz手机", "title": "手机号", "detail": ""], ["icon": "sz密码", "title": "修改登录密码"]], [["icon": "gywm评分", "title": "去评分"], ["icon": "sz开发者", "title": "联系开发者"]], [["icon": "sz关于", "title": "关于情景私语"]]]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //页面返回事件处理
    @IBAction func getbackButtonClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //账号注销事件处理
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "温馨提示", message: "是否注销该账号？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .destructive) { (action) in
            
            let viewController = SWLoginViewController.initViewController()
            UIApplication.shared.keyWindow?.rootViewController = viewController
            UserDefaults.standard.set(nil, forKey: "SWLocalUserInformation_Key")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true) { 
            
        }
        
    }
    
}

//MARK: UITableViewDataSource
extension SWSettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataResource!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dataResource![section] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return SettingTableViewCell.cellForTable(tableView, indexPath: indexPath, data: self.dataResource! , delegate: nil)
    }
    
}

//MARK: UITableViewDelegate
extension SWSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == IndexPath.init(row: 0, section: 0) {
            print("手机号")
            let viewController = SWModifyPhoneViewController.initViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        } else if indexPath == IndexPath.init(row: 1, section: 0) {
            print("修改登录密码")
            let viewController = SWModifyPasswordViewController.initViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        } else if indexPath == IndexPath.init(row: 0, section: 1) {
            print("去评分")
            let appStoreUrl = URL(string: "https://itunes.apple.com/cn/app/%E6%83%85%E6%99%AF%E7%A7%81%E8%AF%AD/id1412772097?mt=8")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appStoreUrl!, options: [:], completionHandler: { (success) in
                    
                })
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(appStoreUrl!)
            }
        } else if indexPath == IndexPath.init(row: 1, section: 1) {
            print("联系开发者")
            let viewController = SWContactUsViewController.initViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
            
        } else if indexPath == IndexPath.init(row: 0, section: 2) {
            print("关于情景私语")
            let viewController = SWAboutMeViewController.initViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
//            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
}










