//
//  UPinAPI.swift
//  uPin
//
//  Created by Ben Rasmussen on 4/9/17.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class UPinAPI {
	static let serverUrl = "http://52.88.13.32/api"
	
	static func loadPins(with filter: PinFilter, completion: (([Pin],Error?)->Void)?) {
		if filter == .taggedLocations {
			FacebookAPI.loadTaggedPlaces(completion: completion)
		}
	}
	
	static func loadPins(completion: (([Pin],Error?)->Void)?) {
		Alamofire.request(serverUrl + "/pins", method: .get).responseData { response in
			if let error = response.error {
				completion?([],error)
			} else if let data = response.result.value {
				let json = JSON(data)
				var pins: [Pin] = []
				
				if let data = json["data"].array {
					for item in data {
						print(item)
						if let title = item["pin_title"].string,
							let longitudeString = item["longitude"].string,
							let latitudeString = item["latitude"].string,
							let id = item["pin_id"].int {
							
							let coordinate = CLLocationCoordinate2D(latitude: Double(latitudeString)!, longitude: Double(longitudeString)!)
							
							
							let pin = Pin(title, coordinate)
							pin.id = String(id)
							pins.append(pin)
						}
						
					}
				}
				
				completion?(pins, nil)
			}
		}
	}
	
	static func addPin(_ pin: Pin, completion: ((Pin?,Error?)->Void)?) {
		let coordinate = pin.coordinate
		
		let parameters: Parameters = ["longitude": coordinate.longitude, "latitude":coordinate.latitude, "pin_title":pin.title]
		
		Alamofire.request(serverUrl + "/pins", method: .post, parameters: parameters).responseData { response in
			if let error = response.error {
				completion?(nil,error)
			} else {
				if let data = response.result.value {
					let json = JSON(data)
					
					if let data = json["data"].dictionary {
						if let id = data["pin_id"]?.int {
							pin.id = String(id)
							
							completion?(pin,nil)
						}
					}
					
				}
			}
		}
	}
	
	static func addThought(with pinID: String, completion: ((Error?)->Void)?) {
		
	}
}
