//
//  SWResentReadCell.swift
//  SceneWhisper
//
//  Created by Yang on 2019/1/21.
//  Copyright © 2019 weipo. All rights reserved.
//

import UIKit

class SWResentReadCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var photoImage: UIImageView!
  
    @IBOutlet var genderImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImage.layer.cornerRadius = 25
        photoImage.clipsToBounds = true
       
      
        
    }
    var readerInfo:Dictionary<String,Any>? {
        didSet {
            photoImage.kf.setImage(with: URL(string: (SWUrlHeader + "\(readerInfo?["userPhoto"] ?? "")")), placeholder: UIImage.init(named: "占位图"), options: nil, progressBlock: nil, completionHandler: nil)
            
            nameLabel.text = readerInfo?["userName"] as? String
            
            let userGender = readerInfo?["userGender"] as! Int
            if userGender == 1 { // 女（红色）
                genderImage.image = UIImage.init(named: "SL男性")
            } else if userGender == 2 { // 男（蓝色）
                genderImage.image = UIImage.init(named: "SL女性")
            } else {
                genderImage.image = UIImage.init(named: "")
            }
        }
    }
    
}

