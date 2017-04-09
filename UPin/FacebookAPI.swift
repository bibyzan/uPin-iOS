//
//  FacebookAPI.swift
//  uPin
//
//  Created by Ben Rasmussen on 4/9/17.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import SwiftyJSON
import CoreLocation

class FacebookAPI {
	static func loadTaggedPlaces(completion: (([Pin], Error?)->Void)?) {
		let graphRequest = FBSDKGraphRequest(graphPath: "/me/tagged_places", parameters: nil)!
		
		graphRequest.start() { connection, result, error in
			if let error = error {
				completion?([],error)
			} else {
				let json = JSON(result)
				var pins: [Pin] = []
				
				if let data = json["data"].array {
					for item in data {
						if let itemDict = item.dictionary {
							if let placesJson = itemDict["place"] {
								let location = placesJson["location"]
								
								if let longitude = location["longitude"].double,
									let latitude = location["latitude"].double {
									
									let itemName = placesJson["name"].string ?? ""
									
									let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
									
									pins.append(Pin(itemName,coordinate))
								}
							}
						}
					}
				}
				
				
				completion?(pins,nil)
			}
		}
	}
}
