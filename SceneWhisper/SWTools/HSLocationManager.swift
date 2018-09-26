//
//  HSLocationManager.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/26.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import CoreLocation


public class HSLocationManager: NSObject {

    public var locationManager: CLLocationManager? = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    public static let sharedInstance: HSLocationManager = {
        return HSLocationManager()
    }()
    
    
    public override init() {
        super.init()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 100.0
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    public func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    public func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    
}

extension HSLocationManager: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationManager?.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location did fail with error: \(error)")
    }
}











