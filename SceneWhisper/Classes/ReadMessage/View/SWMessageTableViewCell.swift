//
//  SWMessageTableViewCell.swift
//  SceneWhisper
//
//  Created by weipo 2017/7/14.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit
import SDWebImage

@objc protocol SWMessageTableViewCellDelegate: NSObjectProtocol {

    @objc optional func cellDidSelectedMoreButton(_ cell: SWMessageTableViewCell)
    
}

class SWMessageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatorImage: UIImageView! //头像
    @IBOutlet weak var nickNameLabel: UILabel! //名称
    @IBOutlet weak var timeLabel: UILabel! //发布时间
    @IBOutlet weak var readCountLabel: UILabel! //可读次数
    @IBOutlet weak var readTimeLabel: UILabel! //可读时间
    @IBOutlet weak var addressLabel: UILabel! //地址
    
    weak var delegate: SWMessageTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        self.delegate = nil
    }

    class func cellForTable(_ tableView: UITableView, messaeInfo: SWMessageInfoModel, delegate: Any?) -> SWMessageTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SWMessageTableViewCell") as! SWMessageTableViewCell
        cell.delegate = delegate as? SWMessageTableViewCellDelegate
        
        cell.avatorImage.sd_setImage(with: URL(string: (SWUrlHeader + messaeInfo.userPhoto)), placeholderImage: UIImage(named: "秘信列表红头像"))
        cell.nickNameLabel.text = messaeInfo.messageTitle
        
        cell.timeLabel.text = messaeInfo.messageAddTime
        if messaeInfo.messageReadTimes == -1 {
            cell.readCountLabel.text = "已读:" + "\(messaeInfo.messageReadedTimes)" + "/" + "∞" 
        } else {
            cell.readCountLabel.text = "已读:" + "\(messaeInfo.messageReadedTimes)" + "/" + "\(messaeInfo.messageReadTimes)"
        }
        
        cell.readTimeLabel.text = "可读时间:每年的" + messaeInfo.messageReadStartMonth + "月" + messaeInfo.messageReadStartDay + "日" + messaeInfo.messageReadStartTime + "时" + "—>" + messaeInfo.messageReadEndMonth + "月" + messaeInfo.messageReadEndDay + "日" + messaeInfo.messageReadEndTime + "时"
        cell.addressLabel.text = messaeInfo.areaName + "-" + messaeInfo.placeName
        
        return cell
    }
    

    
    @IBAction func moreButtonClicked(_ sender: Any) {
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate?.cellDidSelectedMoreButton(_:))) {
            self.delegate!.cellDidSelectedMoreButton!(self)
        }
    }
    
}





