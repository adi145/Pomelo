//
//  LocationsViewController.swift
//  PomeloTask
//
//  Created by Adinarayana Machavarapu on 10/10/21.
//

import UIKit
import CoreLocation

class LocationsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationsTableView: UITableView!
    
    lazy var locationsViewModel: LocationsViewModel = {
        return LocationsViewModel()
    }()
    
    var locationManager : CLLocationManager!
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.setupViewModel()
    }
    
 
    private func setupUI() {
        self.title = Constants.locations_title
        self.activityIndicator.center = self.view.center
        locationsTableView.register(UINib(nibName: Constants.locations_tableview_cell_reusable_identifier, bundle: nil), forCellReuseIdentifier: Constants.locations_tableview_cell_reusable_identifier)
        self.setupBarButtonItems()

    }
    
    private func setupBarButtonItems() {
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(locationAction))
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: nil)
    }
    
    @objc func locationAction(){
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        checkUsersLocationServicesAuthorization()
    }
    
    func checkUsersLocationServicesAuthorization(){
        /// Check if user has authorized Total Plus to use Location Services
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                // This is the first and the ONLY time you will be able to ask the user for permission
                self.locationManager.delegate = self
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                break
                
            case .restricted, .denied:
                // Disable location features
                let alert = UIAlertController(title: Constants.locations_allow_location, message: Constants.locations_disabled_location , preferredStyle: UIAlertController.Style.alert)
                
                // Button to Open Settings
                alert.addAction(UIAlertAction(title: Constants.app_settings, style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: Constants.app_ok, style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable features that require location services here.
                
                locationManager.startUpdatingLocation()
                break
            @unknown default:
                print("Didn't request permission for allow location")
            }
        }
    }
    
    /**
     This method is used to setup viewmodel and databinding when values are changed
     */
    private func setupViewModel() {
        
        locationsViewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.locationsViewModel.alertMessage {
                    self?.popupAlert(title: nil, message: message, actionTitles: [Constants.app_ok], actions: [{ (action) in
                        // print("Ok Tapped")
                    }])
                }
            }
        }
        
        locationsViewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.locationsViewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.isHidden = false
                    self?.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.locationsTableView.alpha = 0.0
                    })
                }else {
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.locationsTableView.alpha = 1.0
                    })
                }
            }
        }
        
        locationsViewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.locationsTableView.reloadData()
            }
        }
        locationsViewModel.fetchLocations()
        
    }
}

extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationsViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.locations_tableview_cell_reusable_identifier, for: indexPath) as? LocationsTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        let cellVM = locationsViewModel.getCellViewModel( at: indexPath )
        cell.locationDisplayViewModel = cellVM
        if selectedIndexPath != nil {
            cell.isLocationSelected(selectedIndexPath: selectedIndexPath!, currentIndex: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.locationsTableView.reloadData()
    }
}

extension LocationsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        UserDefault.setUserLocationEnabledStatus(status: true)
        UserDefault.setValueToUserDefaults(cooridinates: [currentLocation.latitude,currentLocation.longitude])
        self.locationsViewModel.findDistanceWithCurrentLocation(currentLocation: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
}
