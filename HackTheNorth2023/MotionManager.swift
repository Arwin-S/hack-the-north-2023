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
            self.motionManager.accelerometerUpdateInterval = 0.25
            self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.accelerometerData = data
                        self.sendDataToAPI(data)
                    }
                }
            }
        }
        
        if self.motionManager.isGyroAvailable {
            self.motionManager.gyroUpdateInterval = 0.25
            self.motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.gyroscopeData = data
                    }
                }
            }
        }
    }
    
    func sendDataToAPI(_ data: CMAccelerometerData?) {
        print("Getting data from API")
        
        let websiteAddress: String = "http://10.33.136.190:3000/data"
        
        guard let apiURL = URL(string: websiteAddress) else {
            print("ERROR: Cannot convert api address to a URL object")
            return
        }
        
        if let accelerometerData = data {
            // Create a dictionary to hold the data
            let accelerometerDataDict: [String: Any] = [
                "x": accelerometerData.acceleration.x,
                "y": accelerometerData.acceleration.y,
                "z": accelerometerData.acceleration.z
            ]
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: accelerometerDataDict, options: [])
                let jsonString = String(data: jsonData, encoding: .utf8)
                print(jsonString ?? "")
                
                var request = URLRequest(url: apiURL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }
                    
                    if let data = data {
                        // Handle the API response data here
                        print("API Response: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                }.resume()
            } catch {
                print("Error serializing JSON: \(error)")
            }
            
            print("SENT")
        }
        else {
            print("NOT SENT")
        }
    }
    
    func stopUpdates() {
        self.motionManager.stopAccelerometerUpdates()
        self.motionManager.stopGyroUpdates()
    }
}

