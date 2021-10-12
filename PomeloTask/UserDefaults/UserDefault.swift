//
//  UserDefaults.swift
//  PomeloTask
//
//  Created by Adinarayana Machavarapu on 12/10/21.
//

import Foundation

class UserDefault {
    
    static func setUserLocationEnabledStatus(status:Bool) {
        UserDefaults.standard.set(status, forKey: "is_location_enabled")
    }
    static func getUserLocationEnabledStatus() -> Bool {
      return UserDefaults.standard.bool(forKey: "is_location_enabled")
    }
    
    static func setValueToUserDefaults(cooridinates:[Double]) {
        UserDefaults.standard.set(cooridinates, forKey: "current_location")
    }
    static func getCoordinates() -> [Double]{
        return UserDefaults.standard.object(forKey: "current_location") as? [Double] ?? [Double]()
    }
}
