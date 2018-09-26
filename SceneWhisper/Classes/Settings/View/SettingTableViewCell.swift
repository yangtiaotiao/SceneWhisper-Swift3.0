//
//  SettingTableViewCell.swift
//  SceneWhisper
//
//  Created by weipo on 2017/5/22.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var IconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func cellForTable(_ tableView: UITableView, indexPath: IndexPath, data: Array<Array<Dictionary<String, Any>>>, delegate: Any?) -> SettingTableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        let dataInfo = data[indexPath.section][indexPath.row]
        cell.setupView(indexPath, data: dataInfo)
        return cell
    }
    
    func setupView(_ indexPath: IndexPath, data: Dictionary<String, Any>) {
        
        IconView.image = UIImage(named: data["icon"] as! String)
        titleLabel.text = data["title"] as? String
        
        if indexPath.section == 0 && indexPath.row == 0 {
            detailLabel.isHidden = false
            detailLabel.text = data["detail"] as? String
        } else {
            detailLabel.isHidden = true
        }
        
    }
    
    
}










