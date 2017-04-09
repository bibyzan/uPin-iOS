//
//  ViewController.swift
//  UPin
//
//  Created by Ben Rasmussen on 4/8/17.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces

class UPinMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
	@IBOutlet var mapView: GMSMapView!
	
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
		
		//placesClient = GMSPlacesClient.shared()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func pinIt_touchUpInside(sender: UIButton) {
		let alert = UIAlertController(title: "What would you like to name your pin?", message: "What are you starting a conversation about?", preferredStyle: .alert)
		
		//sets blank placeholder for popup
		alert.addTextField(configurationHandler: { (textField) -> Void in
			textField.text = ""
		})
		
		//Grab the value from the text field, and print it when the user clicks OK.
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
			let textField = alert.textFields![0] as UITextField
			let title = textField.text ?? ""
			
			let location = self.currentLocation?.coordinate
			let pin = Pin(title, location!)
			
			_ = pin.getMapInstance(self.mapView)
		}))
		
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

