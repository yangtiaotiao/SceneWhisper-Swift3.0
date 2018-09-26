//
//  MMMessageDetailLayout.swift
//  SceneWhisper
//
//  Created by weipo on 2018/5/13.
//  Copyright © 2018年 weipo. All rights reserved.
//

import UIKit

class MMMessageDetailLayout: UICollectionViewFlowLayout {
    override func prepare() {
        
        //cell的大小
        self.itemSize = CGSize(width: (KScreenWidth-80)/3, height: (KScreenWidth-80)/3)
//        //滑动方向
//        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        //组件四个方位间距
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
}
