//
//  Telemetry.swift
//  GyroTest
//
//  Created by Cody Li on 6/8/16.
//  Copyright © 2016 Cody Li. All rights reserved.
//

import Foundation
import CoreMotion
import MapKit
import CoreLocation
import MessageUI
import UIKit
public class Telemetry {
    
    var accX : Double
    var accY : Double
    var accZ : Double
    var rotX : Double
    var rotY : Double
    var rotZ : Double
    var movementManager : CMMotionManager
    var startTime : NSDate
    var currentTime : NSDate
    var gyroStart : Bool
    var accStart : Bool
    var dataString : NSMutableString
    
    init() {
        self.accX = 0
        self.accY = 0
        self.accZ = 0
        self.rotX = 0
        self.rotY = 0
        self.rotZ = 0
        self.startTime = NSDate()
        self.currentTime = NSDate()
        self.gyroStart = false
        self.accStart = false
        self.dataString = NSMutableString()
        dataString.appendString("Time, Acc X, Acc Y, Acc Z, Rot X, Rot Y, Rot Z\n")
        movementManager = CMMotionManager()
        movementManager.gyroUpdateInterval = 0.1
        movementManager.accelerometerUpdateInterval = 0.1
        
        //Start recording data
        movementManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            self.outputAccData(accelerometerData!.acceleration)
            self.accStart = true
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        
        movementManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
            self.gyroStart = true
            self.outputRotData(gyroData!.rotationRate)
            if (NSError != nil){
                print("\(NSError)")
            }
            
        })
    }
    
    func outputAccData(acceleration: CMAcceleration){
        currentTime = NSDate()
        var timeSinceExecution : Double = currentTime.timeIntervalSinceDate(startTime)
        accX = acceleration.x
        accY = acceleration.y
        accZ = acceleration.z
        
        if(gyroStart && accStart){
            dataString.appendString("\(timeSinceExecution), \(accX), \(accY), \(accZ)")
        }
        
    }
    
    func outputRotData(rotation: CMRotationRate){
        rotX = rotation.x
        rotY = rotation.y
        rotZ = rotation.z
        
        if(gyroStart && accStart){
            dataString.appendString(",\(rotX), \(rotY), \(rotZ)\n")
        }
        //        print(dataString)
    }
    
}