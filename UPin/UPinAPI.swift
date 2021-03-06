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
						if let title = item["pin_title"].string,
							let longitudeString = item["longitude"].string,
							let latitudeString = item["latitude"].string,
							let id = item["pin_id"].int,
							let timeStamp = item["updated_at"].string,
							let sender = item["poster_name"].string {
							
							let coordinate = CLLocationCoordinate2D(latitude: Double(latitudeString)!, longitude: Double(longitudeString)!)
							
							
							let pin = Pin(title, coordinate)
							pin.sender = sender
							pin.timeStamp = timeStamp
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
		
		var parameters: Parameters = ["longitude": coordinate.longitude, "latitude":coordinate.latitude, "pin_title":pin.title]
		
		if let nickname = SettingsViewController.nickname {
			parameters["poster_name"] = nickname
		}
		
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
	
	static func loadThots(with pinID: String, completion: (([Thot],Error?)->Void)?) {
		Alamofire.request(serverUrl + "/pins/" + pinID + "/thots").responseData { response in
			if let error = response.error {
				completion?([],error)
			} else if let data = response.result.value {
				var thots: [Thot] = []
				let json = JSON(data)
				if let data = json["data"].array {
					for item in data {
						if let text = item["thot_text"].string,
							let sender = item["poster_name"].string {
							let thot = Thot(text)
							thot.sender = sender
							thots.append(thot)
						}
						
					}
				}
				completion?(thots,nil)
			}
		}
	}
	
	static func addThot(with pinID: String, _ text: String, completion: ((Error?)->Void)?) {
		var parameters: Parameters = ["pin_id":Int(pinID),"thot_text": text]
		if let nickname = SettingsViewController.nickname {
			parameters["poster_name"] = nickname
		}
		
		Alamofire.request(serverUrl + "/pins/" + pinID + "/thots",method: .post, parameters: parameters).responseData { response in
			if let error = response.error {
				completion?(error)
			} else if let data = response.result.value {
				let json = JSON(data)
				print(json)
				completion?(nil)
			}
		}
	}
}
