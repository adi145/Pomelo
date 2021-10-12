//
//  LocationViewControllerTests.swift
//  PomeloTaskTests
//
//  Created by Adinarayana Machavarapu on 11/10/21.
//

import XCTest
@testable import PomeloTask

class LocationViewControllerTests: XCTestCase {

    var locationsVC : LocationsViewController!
    var locationViewModel: LocationsViewModel!
    var mockApiManager : MockApiManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        locationsVC = storyboard.instantiateViewController(withIdentifier: "LocationsViewController") as? LocationsViewController
        locationsVC.loadView()
        mockApiManager = MockApiManager()
        locationViewModel = LocationsViewModel(networkClient: mockApiManager)
        locationsVC.locationsViewModel = locationViewModel
    }

    func testViewDidLoad() {
        locationsVC.viewDidLoad()
    }
    func testLocationButton() {
        locationsVC.locationAction()
    }
    
    func testHasATableView() {
        XCTAssertNotNil(locationsVC.locationsTableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(locationsVC.locationsTableView.delegate)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(locationsVC.conforms(to: UITableViewDelegate.self))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(locationsVC.locationsTableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(locationsVC.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(locationsVC.responds(to: #selector(locationsVC.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(locationsVC.responds(to: #selector(locationsVC.tableView(_:cellForRowAt:))))
    }

    func testTableViewCellHasReuseIdentifier() {
        locationsVC.locationsViewModel.locationsDisplayViewModel = LocationsMockData.mockLocationDisplayModel()
        locationsVC.locationsTableView.register(UINib(nibName: "LocationsTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationsTableViewCell")
        let cell = locationsVC.tableView(locationsVC.locationsTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? LocationsTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "LocationsTableViewCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }

    func testTableCellHasCorrectLabelText() {
        locationsVC.locationsViewModel.locationsDisplayViewModel = LocationsMockData.mockLocationDisplayModel()
        locationsVC.locationsTableView.register(UINib(nibName: "LocationsTableViewCell", bundle: nil), forCellReuseIdentifier: "LocationsTableViewCell")
        let cell0 = locationsVC.tableView(locationsVC.locationsTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? LocationsTableViewCell
        XCTAssertEqual(cell0?.nameLabel.text, locationsVC.locationsViewModel.locationsDisplayViewModel[0].alias.uppercased())
        
        let cell1 = locationsVC.tableView(locationsVC.locationsTableView, cellForRowAt: IndexPath(row: 1, section: 0)) as? LocationsTableViewCell
        XCTAssertEqual(cell1?.nameLabel.text, locationsVC.locationsViewModel.locationsDisplayViewModel[1].alias.uppercased())
        
        let cell2 = locationsVC.tableView(locationsVC.locationsTableView, cellForRowAt: IndexPath(row: 2, section: 0)) as? LocationsTableViewCell
        XCTAssertEqual(cell2?.nameLabel.text, locationsVC.locationsViewModel.locationsDisplayViewModel[2].alias.uppercased())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        locationsVC = nil
    }
}
