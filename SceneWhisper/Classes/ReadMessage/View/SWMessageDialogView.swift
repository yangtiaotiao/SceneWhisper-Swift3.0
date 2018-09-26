//
//  SWMessageDialogView.swift
//  SceneWhisper
//
//  Created by weipo on 2018/3/9.
//  Copyright © 2018年 weipo. All rights reserved.
//

import UIKit
@objc protocol SWMessageDialogViewDelegate: NSObjectProtocol {
    
    @objc optional func selectFunction(_ view: SWMessageDialogView, messageHandler handleType: Int)
    
}


class SWMessageDialogView: UIView {

    var messageInfoModel: SWMessageInfoModel? {
        didSet {

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let convertedDate = formatter.date(from: (messageInfoModel?.messageAddTime)!)
            
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "yyyy年MM月dd日"
            let dateStr = newDateFormatter.string(from: convertedDate!)
            
            let newTimeFormatter = DateFormatter()
            newTimeFormatter.dateFormat = "HH:mm"
            let timeStr = newTimeFormatter.string(from: convertedDate!)
            
            dateLable.text = dateStr
            timeLabel.text = timeStr
            areaLabel.text = messageInfoModel?.areaName
            placeLable.text = messageInfoModel?.placeName
        }
       
    }
    
   
    weak var delegate: SWMessageDialogViewDelegate?
    var functionHandleType: Int? = 0

    @IBOutlet var dateLable: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var placeLable: UILabel!
    
    static func newInstance() -> SWMessageDialogView?{
        let nibView = Bundle.main.loadNibNamed("SWMessageDialogView", owner: nil, options: nil)
        if let view = nibView?.first as? SWMessageDialogView {
            return view
        }
        return nil
    }
    
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor.color(with: "ffffff", alpha: 0.3)
        self.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight)
       
    }
    
    //查看详细按钮事件处理
    @IBAction func detailButtonClicked(_ sender: Any) {
        self.functionHandleType = 0
        self.messageHandler()
    }
    
    //追踪按钮事件处理
    @IBAction func traceButtonClicked(_ sender: Any) {
        self.functionHandleType = 1
        self.messageHandler()
    }
    
    //删除按钮事件处理
    @IBAction func deleteButtonClicked(_ sender: Any) {
        self.functionHandleType = 2
        self.messageHandler()
    }
    
    //取消按钮事件处理
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.functionHandleType = 3
        self.messageHandler()
    }
    
    func messageHandler() {
        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate?.selectFunction(_:messageHandler:))) {
            self.delegate!.selectFunction!(self, messageHandler: self.functionHandleType!)
        }
    }
}

