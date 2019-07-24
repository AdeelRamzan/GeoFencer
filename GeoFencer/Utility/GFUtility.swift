//
//  GFUtility.swift
//  GeoFencer
//
//  Created by Muhammad Adeel Ramzan on 22/07/2019.
//  Copyright © 2019 Muhammad Adeel Ramzan. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

class GFUtility {
    
    static let shared = GFUtility()
    
    func currentWifiName() -> String? {
        guard let unwrappedCFArrayInterfaces = CNCopySupportedInterfaces() else {
            print("this must be a simulator, no interfaces found")
            return nil
        }
        guard let swiftInterfaces = (unwrappedCFArrayInterfaces as NSArray) as? [String] else {
            print("System error: did not come back as array of Strings")
            return nil
        }
        for interface in swiftInterfaces {
            print("Looking up SSID info for \(interface)") // en0
            guard let unwrappedCFDictionaryForInterface = CNCopyCurrentNetworkInfo(interface as CFString) else {
                print("System error: \(interface) has no information")
                return nil
            }
            guard let SSIDDict = (unwrappedCFDictionaryForInterface as NSDictionary) as? [String: AnyObject] else {
                print("System error: interface information is not a string-keyed dictionary")
                return nil
            }
            
            if let name = SSIDDict["SSID"] as? String {
                return name
            } else {
                return nil
            }
        }
        
        return nil
    }
}
