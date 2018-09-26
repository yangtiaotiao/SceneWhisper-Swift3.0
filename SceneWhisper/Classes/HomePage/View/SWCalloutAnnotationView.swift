//
//  SWCalloutAnnotationView.swift
//  SceneWhisper
//
//  Created by weipo 2017/10/24.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit
import MapKit

class SWCalloutAnnotationView: MKAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var contentView: UIView?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.canShowCallout = false
//        self.frame = 
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
