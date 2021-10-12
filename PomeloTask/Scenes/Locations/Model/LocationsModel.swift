//
//  LocationsModel.swift
//  PomeloTask
//
//  Created by Adinarayana Machavarapu on 10/10/21.
//


// MARK: - Locations
struct LocationsModel: Codable {
    let numberOfNewLocations: Int
    let pickup: [Pickup]

    enum CodingKeys: String, CodingKey {
        case numberOfNewLocations = "number_of_new_locations"
        case pickup
    }
}

// MARK: - Pickup
struct Pickup: Codable {
    let alias, address1, city: String
    let latitude, longitude: Double?
    let active: Bool


    enum CodingKeys: String, CodingKey {
        case alias, address1, city, latitude, longitude
        case active
    }
}

// MARK: - LocationsDisplayViewModel
struct LocationsDisplayViewModel{
    let alias, address1, city: String
    let latitude, longitude: Double
    var distance : Double = 0
    var shouldShowDistance = false
}


