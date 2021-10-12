//
//  LocationsViewModel.swift
//  PomeloTask
//
//  Created by Adinarayana Machavarapu on 10/10/21.
//

import CoreLocation

protocol LocationsViewModelProtocol {
    func fetchLocations()
}

class LocationsViewModel {
    
    let networkClient: NetworkClient
    var pickupLocations : [Pickup]?
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    /**
    This observer property is going to call show all the pickup locations details to users when values are assigned
        */
    var locationsDisplayViewModel: [LocationsDisplayViewModel] = [LocationsDisplayViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    /**
    This observer property is going to show indicator beforing going to call api & hide after getting response from  the api success or fail.
        */
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    /**
    This observer property is going to show error message to user when the netwrok return error
        */
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    /**
    returning total pickuplocation count
        
     - returns: locationsDisplayViewModel count
     */
    var numberOfCells: Int {
        return locationsDisplayViewModel.count
    }
    
    /**
   Get indexpath from the cell and returning with  pickuplocations to display pickup location details
     
     - parameter indexPath: IndexPath
     
     - returns: LocationsDisplayViewModel
     */
    func getCellViewModel( at indexPath: IndexPath ) -> LocationsDisplayViewModel {
        return locationsDisplayViewModel[indexPath.row]
    }
    
}

extension LocationsViewModel: LocationsViewModelProtocol {
  
    /**
      Fetch locations details from server  and  filerting  data before going to display.
      */
    func fetchLocations() {
        self.isLoading = true
        networkClient.request(type: LocationsModel.self, service: ApiEndpoints.pickupLocations) { [weak self] response in
            switch response {
            case.success(let locationsModel):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    if locationsModel.pickup.count == 0 {
                        self?.isLoading = false
                        self?.alertMessage = "Some unable to find the locations. please try again"
                        return
                    }
                    self?.pickupLocations = locationsModel.pickup.filter{ $0.active == true }
                    guard let filteredLocations = self?.pickupLocations else {
                        return
                    }
                    self?.locationsDisplayViewModel = self?.getLocationListViewModelData(response: filteredLocations) ?? []

                    if UserDefault.getUserLocationEnabledStatus(){
                        let customerLocation = UserDefault.getCoordinates()
                        if customerLocation.count > 0 && customerLocation.count == 2{
                            self?.findDistanceWithCurrentLocation(currentLocation: CLLocation(latitude: customerLocation[0], longitude: customerLocation[1]))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    let errorObject = NetworkError.getTheErrorMessage(error: error)
                    self?.alertMessage = errorObject
                }
            }
        }
    }
    
    func calculateDistance(currentLocation:CLLocation, destination:CLLocation) -> Double {
        return currentLocation.distance(from: destination) / 1000
    }
    
    /**
     This method used to create list of LocationsDisplayViewModel with required properties and sorting data descending order
     
     - parameter response: Pickup Model
     
     - returns: Array of LocationsDisplayViewModel
     */
    private func getLocationListViewModelData(response: [Pickup]) -> [LocationsDisplayViewModel]{
        var locationsObjects = [LocationsDisplayViewModel]()
        for location in response {
            if location.alias != ""{
                let object = LocationsDisplayViewModel(alias: location.alias, address1: location.address1, city: location.city, latitude: location.latitude ?? 0, longitude: location.longitude ?? 0)
                locationsObjects.append(object)
            }
        }
        return locationsObjects
    }
    
    /**
     This method used to find the distance between from user current with pickup locations & doing sorting with ascending order & reload tableview.
     
     - parameter currentLocation: CLLocation
     
     - returns: Array of LocationsDisplayViewModel
     */
    func findDistanceWithCurrentLocation(currentLocation:CLLocation) {
        for (index, destination) in self.locationsDisplayViewModel.enumerated() {
            let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
            let distance = calculateDistance(currentLocation: currentLocation, destination: destinationLocation)
            self.locationsDisplayViewModel[index].distance =  distance  //String(format: "%.01f km", distance)
            self.locationsDisplayViewModel[index].shouldShowDistance = true
        }
        let sortedLocation = locationsDisplayViewModel.sorted { $0.distance < $1.distance }
        if sortedLocation.count > 0 {
            self.locationsDisplayViewModel.removeAll()
            self.locationsDisplayViewModel = sortedLocation
        }
    }
}
