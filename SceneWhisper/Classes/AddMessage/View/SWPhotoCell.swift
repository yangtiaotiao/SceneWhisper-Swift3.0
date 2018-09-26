//
//  SWPhotoCell.swift
//  SceneWhisper
//
//  Created by weipo on 2018/3/24.
//  Copyright © 2018年 weipo. All rights reserved.
//

import UIKit

class SWPhotoCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    var radius:CGFloat! {
        didSet {
            
            imageView.layer.cornerRadius = radius
            imageView.layer.borderColor = UIColor.color(with: "514953", alpha: 1.0).cgColor
            imageView.layer.borderWidth = 2
            imageView.layer.masksToBounds = true
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    

}
