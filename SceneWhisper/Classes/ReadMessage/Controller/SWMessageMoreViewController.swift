//
//  SWMessageMoreViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2017/6/13.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

class SWMessageMoreViewController: UIViewController {

    
    
    @IBOutlet weak var dateLabel: UILabel! //日期label
    @IBOutlet weak var timeLabel: UILabel! //时间label
    @IBOutlet weak var addressLabel: UILabel! //地址label
    @IBOutlet weak var streetLabel: UILabel! //街道label
    @IBOutlet weak var backgroudImageView: UIImageView! //背景图片
    
    //初始化viewController
    class func initViewController() -> SWMessageMoreViewController {
        return UIStoryboard.init(name: "ReadMessage", bundle: nil).instantiateViewController(withIdentifier: "SWMessageMoreViewController") as! SWMessageMoreViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //为背景添加点击手势事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(getbackAction))
        tap.numberOfTapsRequired = 1
        backgroudImageView.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //页面返回事件处理
    func getbackAction() {
        self.dismiss(animated: true) { 
            
        }
    }
    
    //查看详细按钮事件处理
    @IBAction func detailButtonClicked(_ sender: Any) {
        
        //查看详情处理
//        let viewController = SecretLetterViewController.initViewController()
//        self.presentedViewController?.navigationController?.pushViewController(viewController, animated: true)
        self.dismiss(animated: true) {
           
        }
    }
    
    //追踪按钮事件处理
    @IBAction func traceButtonClicked(_ sender: Any) {
        
        //追踪处理
        
        self.dismiss(animated: true) {
            
        }
    }
    
    //删除按钮事件处理
    @IBAction func deleteButtonClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "温馨提示", message: "是否删除该相片？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .destructive) { (action) in
            
            //删除处理
            
            self.dismiss(animated: true) { }
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true) {
            
        }
        
    }

    //取消按钮事件处理
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        //取消操作
        
        self.dismiss(animated: true) {
            
        }
    }
    
}




