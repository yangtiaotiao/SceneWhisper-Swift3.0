//
//  CameraSelectViewController.swift
//  SceneWhisper
//
//  Created by weipo 2017/5/9.
//  Copyright © 2017年 weipo. All rights reserved.
//  选择相机还是拍摄电影卡板

import UIKit

@objc protocol CameraSelectViewControllerDelegate: NSObjectProtocol {
    
    @objc optional func selectView(_ view: CameraSelectViewController, didDismissHandler handleType: Int)
    
}

class CameraSelectViewController: UIViewController {
    
    @IBOutlet weak var movieCardBoard: UIView!
    @IBOutlet weak var movieCardBoardBar: UIImageView!
    
    weak var delegate: CameraSelectViewControllerDelegate?
    var dismissHandleType: Int? = 0

    //初始化viewController
    class func initViewController() -> CameraSelectViewController {
        return UIStoryboard.init(name: "AddMessage", bundle: nil).instantiateViewController(withIdentifier: "CameraSelectViewController") as! CameraSelectViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //设置电影卡板
        let centerX = movieCardBoardBar.bounds.size.width / 2.0
        let centerY = movieCardBoardBar.bounds.size.height / 2.0
        let x = movieCardBoardBar.bounds.origin.x
        let y = movieCardBoardBar.bounds.maxY
        
        movieCardBoardBar.layer.allowsEdgeAntialiasing = true
        let transform = self.getCGAffineTransformRotateAroundPoint(centerX, centerY: centerY, x: x, y: y, angle: -CGFloat(Double.pi * 5.0 / 180.0))
        movieCardBoardBar.transform = CGAffineTransform.identity
        movieCardBoardBar.transform = transform
        
    }


    deinit {
        self.delegate = nil
    }
    
    //点击其它地方页面dismiss
    @IBAction func touchAnywhereHiddenView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //照相按钮事件处理
    @IBAction func photoButtonClicked(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.movieCardBoardBar.transform = CGAffineTransform.identity
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            strongSelf.dismissHandleType = 0
            strongSelf.dismissHandler()
            
        }
        
    }
   
    //视频按钮事件处理
    @IBAction func videoButtonClicked(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.movieCardBoardBar.transform = CGAffineTransform.identity
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            strongSelf.dismissHandleType = 1
            strongSelf.dismissHandler()
            
        }

    }
    
    
    //获取转动效果
    func getCGAffineTransformRotateAroundPoint(_ centerX: CGFloat, centerY: CGFloat, x: CGFloat, y: CGFloat, angle: CGFloat) -> CGAffineTransform {
        
        let tempX = x - centerX
        let tempY = y - centerY
        
        var trans = CGAffineTransform(translationX: tempX, y: tempY)
        trans = trans.rotated(by: angle)
        trans = trans.translatedBy(x: -tempX, y: -tempY)
        return trans
        
    }
    
    //页面dismiss处理
    func dismissHandler() {
        
        self.dismiss(animated: false) { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.delegate != nil && strongSelf.delegate!.responds(to: #selector(strongSelf.delegate?.selectView(_:didDismissHandler:))) {
                strongSelf.delegate!.selectView!(strongSelf, didDismissHandler: strongSelf.dismissHandleType!)
            }
        }
        
    }
    
}






