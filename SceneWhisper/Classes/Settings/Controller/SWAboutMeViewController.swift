//
//  SWAboutMeViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/5/31.
//  Copyright © 2017年 weipo. All rights reserved.
//  关于我们

import UIKit

class SWAboutMeViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView! //
    @IBOutlet weak var agreementLabel: UILabel! //用户协议Label
    @IBOutlet weak var copyrightLabel: UILabel! //所有权Label
    @IBOutlet weak var versionLabel: UILabel! //版本号Label
    
    var dataResource: Array<Array<Dictionary<String, Any>>>?

    //初始化viewController
    class func initViewController() -> SWAboutMeViewController {
        return UIStoryboard.init(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SWAboutMeViewController") as! SWAboutMeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //设置页面标题
        self.title = "关于我们"
        
        //为用户协议Label添加点击事件
        agreementLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(agreementHandler(_:)))
        tap.numberOfTapsRequired = 1
        agreementLabel.addGestureRecognizer(tap)
        
        //初始化tableView的dataResource
        dataResource = [[["icon": "gywm评分", "title": "去评分"],
        ["icon": "gywm新功能介绍", "title": "功能介绍"],
        ["icon": "gywm---Chat", "title": "系统通知"]],
        [["icon": "gywm关于", "title": "关于我们"]],[["icon": "gywm投诉", "title": "投诉"]]]
        
        //获取App版本号
        versionLabel.text = "情景私语V" + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String);
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //页面返回事件处理
    @IBAction func getbackButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //用户协议点击事件处理
    func agreementHandler(_ sender: UITapGestureRecognizer) {
        print("协议！")
        let viewController = SWCommonWebViewController.initViewController()
        viewController.commonRequest = URLRequest(url: URL(string: "http://www.shengzhe.org/scenechat/m/u/userProtocol")!)
        viewController.title = "用户协议"
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}


//MARK: UITableViewDataSource
extension SWAboutMeViewController: UITableViewDataSource {
    
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
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return AboutMeTableViewCell.cellForTable(tableView, indexPath: indexPath, data: self.dataResource!, delegate: nil)
    }
    
}

//MARK: UITableViewDelegate
extension SWAboutMeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == IndexPath.init(row: 0, section: 0) {
            print("去评分")
        } else if indexPath == IndexPath.init(row: 1, section: 0) {
            print("功能介绍")
        } else if indexPath == IndexPath.init(row: 2, section: 0) {
            print("系统通知")
        } else if indexPath == IndexPath.init(row: 0, section: 1) {
            print("关于我们")
        } else if indexPath == IndexPath.init(row: 0, section: 2) {
            print("投诉")
        }
    }
    
    
}








