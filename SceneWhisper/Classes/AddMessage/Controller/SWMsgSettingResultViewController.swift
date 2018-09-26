//
//  SWMsgSettingResultViewController.swift
//  SceneWhisper
//
//  Created by weipo on 2018/3/25.
//  Copyright © 2018年 weipo. All rights reserved.
//

import UIKit


@objc protocol SWMsgSetResultVCDelegate: NSObjectProtocol {
    
    @objc optional func messageSetResultComfir()
}
class SWMsgSettingResultViewController: UIViewController {
    weak var delegate: SWMsgSetResultVCDelegate?
    var model: SWMessageInfoModel!
    @IBOutlet var monthView: UIView!
    
    @IBOutlet var dayView: UIView!
   
    @IBOutlet var timeView: UIView!
    @IBOutlet var readTimesView: UIView!
    
    @IBOutlet var keyView: UIView!
    @IBOutlet var scopeView: UIView!

    
    //初始化viewController
    class func initViewController() -> SWMsgSettingResultViewController {
        return UIStoryboard.init(name: "AddMessage", bundle: nil).instantiateViewController(withIdentifier: "SWMsgSettingResultViewController") as! SWMsgSettingResultViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let monthText = model.readStartMonth + "月" + "-" + model.readEndMonth + "月"
        let monthCicle = ZZCircleProgress.init(frame: monthView.bounds, currentText:monthText, pathBack: UIColor.color(with: "dcdcdc"), pathFill: UIColor.color(with: "AB66FF"), startAngle: -90, strokeWidth: 2.0)
        monthCicle?.progress = CGFloat(Float(model.readEndMonth)! - Float(model.readStartMonth)! + 1)/12
        self.monthView.addSubview(monthCicle!)
        
        let dayText = model.readStartDay + "日" + "-" + model.readEndDay + "日"
        let dayCicle = ZZCircleProgress.init(frame: monthView.bounds, currentText:dayText, pathBack: UIColor.color(with: "dcdcdc"), pathFill: UIColor.color(with: "50d2c2"), startAngle: -90, strokeWidth: 2.0)
        dayCicle?.progress = CGFloat(Float(model.readEndDay)! - Float(model.readStartDay)! + 1)/31
        self.dayView.addSubview(dayCicle!)
        
        let timeText = model.readStartTime + "时" + "-" + model.readEndTime + "时"
        let timeCicle = ZZCircleProgress.init(frame: monthView.bounds, currentText:timeText, pathBack: UIColor.color(with: "dcdcdc"), pathFill: UIColor.color(with: "fcab53"), startAngle: -90, strokeWidth: 2.0)
        timeCicle?.progress = CGFloat(Float(model.readEndTime)! - Float(model.readStartTime)!)/24
        self.timeView.addSubview(timeCicle!)
        
        let scopetext = "\(model.scope)" + "米"
        let scopeCicle = ZZCircleProgress.init(frame: monthView.bounds, currentText:scopetext, pathBack: UIColor.color(with: "dcdcdc"), pathFill: UIColor.color(with: "AB66FF"), startAngle: -90, strokeWidth: 2.0)
        scopeCicle?.progress = CGFloat(model.scope)/1000
        self.scopeView.addSubview(scopeCicle!)
        
        
        var readTiemstext = ""
        var readTiemsprogres:CGFloat
        if model.readTimes == -1 {
            readTiemstext = "无限次"
            readTiemsprogres = 1.0
        } else {
            readTiemstext = "\(model.readTimes)" + "次"
            readTiemsprogres = CGFloat(model.readTimes)/1000
        }
        let readTiemsCicle = ZZCircleProgress.init(frame: monthView.bounds, currentText:readTiemstext, pathBack: UIColor.color(with: "dcdcdc"), pathFill: UIColor.color(with: "50D2C2"), startAngle: -90, strokeWidth: 2.0)
        readTiemsCicle?.progress = readTiemsprogres
        self.readTimesView.addSubview(readTiemsCicle!)
        
        var keytext = ""
        var keyprogress:CGFloat
        if model.keyId == -1 {
            keytext = "无"
            keyprogress = 0
        } else {
            keytext = "有"
            keyprogress = 1.0
        }
        let keyCicle = ZZCircleProgress.init(frame: monthView.bounds, currentText:keytext, pathBack: UIColor.color(with: "dcdcdc"), pathFill: UIColor.color(with: "FCAB53"), startAngle: -90, strokeWidth: 2.0)
        keyCicle?.progress = keyprogress
        self.keyView.addSubview(keyCicle!)
        
    }

    
    @IBAction func reviseBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func comfirBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate!.messageSetResultComfir)) {
            self.delegate!.messageSetResultComfir!()
        }
       
    }
    
}
