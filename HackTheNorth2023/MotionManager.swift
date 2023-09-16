//
//  MotionManager.swift
//  HackTheNorth2023
//
//  Created by Kao Kwan Yin on 16/9/2023.
//

import Foundation
import Combine
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var accelerometerData: CMAccelerometerData?
    @Published var gyroscopeData: CMGyroData?
    
    init() {
        self.startUpdates()
    }
    
    func startUpdates() {
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 1.0
            self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.accelerometerData = data
                    }
                }
            }
        }
        
        if self.motionManager.isGyroAvailable {
            self.motionManager.gyroUpdateInterval = 1.0
            self.motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.gyroscopeData = data
                    }
                }
            }
        }
    }
    
    func stopUpdates() {
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopGyroUpdates()
    }
}

