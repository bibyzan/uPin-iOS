//
//  ViewController.swift
//  UPin
//
//  Created by Ben Rasmussen on 4/8/17.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit
import GoogleMaps
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
//import GooglePlaces

class UPinMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
	@IBOutlet var mapView: GMSMapView!
	@IBOutlet var filterStepper: UIStepper!
	@IBOutlet var filterSwitch: UISwitch!
	@IBOutlet var filterLabel: UILabel!
	
	var facebookLoginButton: LoginButton!
	
	var apiPins: [Pin] = []
	var filterPins: [PinFilter:[Pin]] = [:]
	var filters: [PinFilter:Bool] = [.nearbyPlaces:false,.taggedLocations:false,.nearbyEvents:false]
	var locationManager = CLLocationManager()
	var currentLocation: CLLocation?
	//var placesClient: GMSPlacesClient!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		locationManager = CLLocationManager()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()
		locationManager.distanceFilter = 50
		locationManager.startUpdatingLocation()
		locationManager.delegate = self
		
		mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		mapView.isMyLocationEnabled = true
		mapView.accessibilityElementsHidden = false
		//mapView.settings.myLocationButton = true
		mapView.isHidden = true
		mapView.delegate = self
		
		filterStepper.maximumValue = Double(filters.count - 1)
		filterStepper.wraps = true
		
		let filter = [PinFilter](filters.keys)[Int(filterStepper.value)]
		filterLabel.text = filter.rawValue
		
		facebookLoginButton = LoginButton(readPermissions: [ .publicProfile, .custom("user_posts"),.custom("user_tagged_places")])
		
		facebookLoginButton.frame.origin = CGPoint(x: self.view.frame.width - 200, y: self.view.frame.height - 36)
		
		self.view.addSubview(facebookLoginButton)
		
		UPinAPI.loadPins() { pins, error in
			if !wasErrorFromServer(self, "Getting Pins", error) {
				self.apiPins = pins
				for pin in pins {
					pin.setMapInstance(self.mapView)
				}
			}
		}
		
		//placesClient = GMSPlacesClient.shared()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func stepperValueChanged(sender: UIStepper) {
		let filterArr = [PinFilter](filters.keys)
		let filter = filterArr[Int(filterStepper.value)]
		
		if let filterSetting = filters[filter] {
			filterLabel.text = filter.rawValue
			filterSwitch.setOn(filterSetting, animated: true)
		}
		
	}
	
	@IBAction func filterSwitched(_ sender: AnyObject) {
		let filter = [PinFilter](filters.keys)[Int(filterStepper.value)]
		filters[filter] = filterSwitch.isOn
		
		if filterSwitch.isOn {
			UPinAPI.loadPins(with: filter) { pins, error in
				if error == nil {
					self.filterPins[filter] = pins
					
					for pin in pins {
						pin.setMapInstance(self.mapView)
					}
				}
			}
		} else {
			if let pins = filterPins[filter] {
				for pin in pins {
					pin.mapInstance?.map = nil
				}
			}
			filterPins[filter] = []
		}
		
	}
	
	@IBAction func pinIt_touchUpInside(sender: UIButton) {
		let alert = UIAlertController(title: "What would you like to name your pin?", message: "", preferredStyle: .alert)
		
		//sets blank placeholder for popup
		alert.addTextField(configurationHandler: { (textField) -> Void in
			textField.text = ""
		})
		
		//Grab the value from the text field, and print it when the user clicks OK.
		alert.addAction(UIAlertAction(title: "pin it!", style: .default, handler: { (action) -> Void in
			let textField = alert.textFields![0] as UITextField
			let title = textField.text ?? ""
			
			
			let location = self.currentLocation?.coordinate
			let pin = Pin(title, location!)
			
			UPinAPI.addPin(pin) { pin, error in
				if !wasErrorFromServer(self, "Adding pin",error) {
					pin?.setMapInstance(self.mapView)
					self.apiPins.append(pin!)
				}
			}
		}))
		
		alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}

	//MARK: CLLocationManagerDelegate methods
	
	// Handle incoming location events.
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let location: CLLocation = locations.last!
		print("Location: \(location)")
		
		let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
		                                      longitude: location.coordinate.longitude,
		                                      zoom: mapView.camera.zoom)
		currentLocation = location
		if mapView.isHidden {
			mapView.isHidden = false
			mapView.camera = camera
		} else {
			//mapView.animate(to: camera)
		}
		
	}
	
	// Handle authorization for the location manager.
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .restricted:
			print("Location access was restricted.")
		case .denied:
			print("User denied access to location.")
			// Display the map using the default location.
			mapView.isHidden = false
		case .notDetermined:
			print("Location status not determined.")
		case .authorizedAlways: fallthrough
		case .authorizedWhenInUse:
			print("Location status is OK.")
		}
	}
	
	// Handle location manager errors.
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		locationManager.stopUpdatingLocation()
		print("Error: \(error)")
	}
}

