//
//  AboutMeTableViewCell.swift
//  SceneWhisper
//
//  Created by weipo on 2017/5/31.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

class AboutMeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    class func cellForTable(_ tableView: UITableView, indexPath: IndexPath, data: Array<Array<Dictionary<String, Any>>>, delegate: Any?) -> AboutMeTableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeTableViewCell", for: indexPath) as! AboutMeTableViewCell
        let dataInfo = data[indexPath.section][indexPath.row]
        cell.setupView(indexPath, data: dataInfo)
        return cell
    }
    
    func setupView(_ indexPath: IndexPath, data: Dictionary<String, Any>) {
        
        iconView.image = UIImage(named: data["icon"] as! String)
        titleLabel.text = data["title"] as? String
        
        
    }
    
    
}
