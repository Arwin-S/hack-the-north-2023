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
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
