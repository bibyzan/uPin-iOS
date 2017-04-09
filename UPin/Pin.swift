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
	var id: String?
	var mapInstance: GMSMarker?
	var coordinate: CLLocationCoordinate2D
	var dataSource: String?
	var title: String
	var description: String?
	
	init(_ title: String,_ coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
		self.title = title
	}
	
	func setMapInstance(_ view: GMSMapView) {
		if let _ = mapInstance {
			//already made
		} else {
			mapInstance = GMSMarker()
			if let _ = id {
				//is api pin
			} else {
				mapInstance?.title = title
			}
			
			mapInstance?.position = coordinate
			mapInstance?.iconView = UIImageView(image: UIImage(named: "redpin.png"))
			mapInstance?.iconView?.frame.size = CGSize(width: 60, height: 60)
			mapInstance?.map = view
		}
	}
}
