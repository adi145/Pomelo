//
//  MockLocationsDisplayViewModelData.swift
//  PomeloTaskTests
//
//  Created by Adinarayana Machavarapu on 11/10/21.
//

import Foundation
@testable import PomeloTask

class LocationsMockData{
   
    class func mockLocationDisplayModel() -> [LocationsDisplayViewModel] {
        return [LocationsDisplayViewModel(alias: "All Seasons", address1: "Unit 205 Level 2 CRC building, All Seasons Place87 Wireless Road,", city: "Bangkok", latitude: 13.739272, longitude: 100.548268),
                LocationsDisplayViewModel(alias: "CentralWorld", address1: "Unit B218, Level 2, Central World, 999/9 Rama I Rd", city: "Bangkok", latitude: 13.747312, longitude: 100.539631),
                LocationsDisplayViewModel(alias: "FABLAB: Siam Center", address1: "สยามเซ็นเตอร์ ชั้น 1 โซนวิชั่นนารี", city: "Bangkok", latitude: 13.746318, longitude: 100.53267),
                LocationsDisplayViewModel(alias: "Yuda Shop", address1: "เกทเวย์ เอกมัย ชั้น 2 ห้องเลขที่ 982/22", city: "Bangkok", latitude: 13.718879, longitude: 100.5850693),
                LocationsDisplayViewModel(alias: "Baan Dada Children\'s Home and Co", address1: "116 Moo 6", city: "Kanchanaburi", latitude: 15.17352, longitude: 98.359504)]
    }
    
    class func getDataFromJson() -> Data? {
       if let path = Bundle(for: self).path(forResource: "locations", ofType: "json") {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch {
                return nil
            }
        }
        return nil
    }
    
   
}
