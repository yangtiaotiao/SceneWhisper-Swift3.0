//
//  Coordinate2DExtension.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/17.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import CoreLocation


extension CLLocationCoordinate2D {

    func latitudeString() -> String {
        
        let latString = self.latitude.description
        let latComponet = latString.components(separatedBy: ".")
        let degree = latComponet.first
        let minuteString = String.init(format: "0.%@", latComponet.last!)
        let mintteValue = Double(minuteString)! * 60.0
        let minuteComponet = mintteValue.description.components(separatedBy: ".")
        let minute = minuteComponet.first
        let secondString = String.init(format: "0.%@", minuteComponet.last!)
        let secondValue = Double(secondString)! * 60.0
        let secondCompont = secondValue.description.components(separatedBy: ".")
        let second = secondCompont.first
        return String.init(format: "%@°%@'%@\"", degree!, minute!, second!)
        
    }
    
    func longitudeString() -> String {
        
        let longString = self.longitude.description
        let longComponet = longString.components(separatedBy: ".")
        let degree = longComponet.first
        let minuteString = String.init(format: "0.%@", longComponet.last!)
        let mintteValue = Double(minuteString)! * 60.0
        let minuteComponet = mintteValue.description.components(separatedBy: ".")
        let minute = minuteComponet.first
        let secondString = String.init(format: "0.%@", minuteComponet.last!)
        let secondValue = Double(secondString)! * 60.0
        let secondCompont = secondValue.description.components(separatedBy: ".")
        let second = secondCompont.first
        return String.init(format: "%@°%@'%@\"", degree!, minute!, second!)
        
    }

    func NorthOrSouth() -> String {
        if self.latitude < 0.0 {
            return "S"
        } else {
            return "N"
        }
    }
    
    func EastOrWest() -> String {
        if self.longitude < 0.0 {
            return "W"
        } else {
            return "E"
        }
    }
    
}







