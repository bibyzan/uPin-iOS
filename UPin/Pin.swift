//
//  Pin.swift
//  UPin
//
//  Created by Ben Rasmussen on 4/9/17.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation
import GoogleMaps

class Pin {
	var mapInstance: GMSMarker?
	var coordinate: CLLocationCoordinate2D
	var dataSource: String?
	var title: String
	var description: String?
	
	init(_ title: String,_ coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
		self.title = title
	}
	
	func getMapInstance(_ view: GMSMapView)->GMSMarker {
		if let instance = mapInstance {
			return instance
		} else {
			mapInstance = GMSMarker()
			mapInstance?.position = coordinate
			mapInstance?.iconView = UIImageView(image: UIImage(named: "redpin.png"))
			mapInstance?.map = view
			
			return mapInstance!
		}
	}
}
