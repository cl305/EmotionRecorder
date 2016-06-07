//
//  Telemetry.swift
//  EmotionRecorder
//
//  Created by Cody Li on 6/7/16.
//  Copyright © 2016 Cody Li. All rights reserved.
//

import Foundation
import CoreMotion
import MapKit
import CoreLocation

import UIKit
public class Telemetry {
    
    var accX : Double
    var accY : Double
    var accZ : Double
    var rotX : Double
    var rotY : Double
    var rotZ : Double
    var movementManager : CMMotionManager
    
    init() {
        self.accX = 0
        self.accY = 0
        self.accZ = 0
        self.rotX = 0
        self.rotY = 0
        self.rotZ = 0
        movementManager = CMMotionManager()
        movementManager.gyroUpdateInterval = 0.2
        movementManager.accelerometerUpdateInterval = 0.2
       
        //Start recording data
        movementManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            
            self.outputAccData(accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        
        movementManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
            self.outputRotData(gyroData!.rotationRate)
            if (NSError != nil){
                print("\(NSError)")
            }
            
        })
    }
    
    func outputAccData(acceleration: CMAcceleration){
        accX = acceleration.x
        accY = acceleration.y
        accZ = acceleration.z
        print("Acceleration X: \(accX)")
        print("Acceleration Y: \(accY)")
        print("Acceleration Z: \(accZ) \n")
    }
    
    func outputRotData(rotation: CMRotationRate){
        rotX = rotation.x
        rotY = rotation.y
        rotZ = rotation.z
        print("Rotation X: \(rotX)")
        print("Rotation Y: \(rotY)")
        print("Rotation Z: \(rotZ)")
    }
    
}