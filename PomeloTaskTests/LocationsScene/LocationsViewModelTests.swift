//
//  LocationsViewModelTests.swift
//  PomeloTaskTests
//
//  Created by Adinarayana Machavarapu on 11/10/21.
//

import XCTest
import CoreLocation
@testable import PomeloTask

class LocationsViewModelTests: XCTestCase {
    var locationsVM: LocationsViewModel!
    var mockApiManager: MockApiManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockApiManager = MockApiManager()
        locationsVM = LocationsViewModel(networkClient: mockApiManager)
    }
    
    func testFetchLocationWithSuccess() {
        let success = expectation(description: "fetchLocations")
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            success.fulfill()
        }
        mockApiManager.isShowErrorForLocations = false
        locationsVM.fetchLocations()
        waitForExpectations(timeout: 15, handler: nil)
        XCTAssertNotNil(locationsVM.pickupLocations)
    }
   
    func testFetchLocationWithFail() {
        let completedExpectation = expectation(description: "showError")
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            completedExpectation.fulfill()
        }
        mockApiManager.isShowErrorForLocations = true
        locationsVM.fetchLocations()
        waitForExpectations(timeout: 8, handler: nil)
        XCTAssertNil(locationsVM.pickupLocations)
    }

    func testCellForAtIndexDisplayViewModel() {
        locationsVM.locationsDisplayViewModel = LocationsMockData.mockLocationDisplayModel()
        let indexPath = IndexPath(row: 0, section: 0)
        let rowViewModel = locationsVM.getCellViewModel(at: indexPath)
        XCTAssertEqual(rowViewModel.alias, locationsVM.locationsDisplayViewModel[0].alias)
    }
    
    func testFindDistanceWithCurrentLocation() {
        locationsVM.locationsDisplayViewModel = LocationsMockData.mockLocationDisplayModel()
        locationsVM.findDistanceWithCurrentLocation(currentLocation: CLLocation(latitude: 13.739272, longitude: 100.548268))
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        locationsVM = nil
    }
}
