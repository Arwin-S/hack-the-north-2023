//
//  ContentView.swift
//  HackTheNorth2023
//
//  Created by Kao Kwan Yin on 16/9/2023.
//
import SwiftUI
import CoreMotion

struct ContentView: View {
    @ObservedObject var motionManager = MotionManager()
    
    var body: some View {
        VStack {
            if let accelerometerData = motionManager.accelerometerData {
                Text("Accelerometer Data:")
                Text("X: \(accelerometerData.acceleration.x)")
                Text("Y: \(accelerometerData.acceleration.y)")
                Text("Z: \(accelerometerData.acceleration.z)")
            } else {
                Text("No accelerometer data available")
            }
            
            Divider()
            
            if let gyroscopeData = motionManager.gyroscopeData {
                Text("Gyroscope Data:")
                Text("X: \(gyroscopeData.rotationRate.x)")
                Text("Y: \(gyroscopeData.rotationRate.y)")
                Text("Z: \(gyroscopeData.rotationRate.z)")
            } else {
                Text("No gyroscope data available")
            }
        }.padding()
        .onAppear {
            sendDataToAPI()
        }
    }
    
    func sendDataToAPI() {
        print("Getting data from API")
        
        let websiteAddress: String = "https://10.33.136.190:3000/data"
        
        guard let apiURL = URL(string: websiteAddress) else {
            print("ERROR: Cannot convert api address to a URL object")
            return
        }
        
        if let accelerometerData = motionManager.accelerometerData {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
