//
//  Thought.swift
//  UPin
//
//  Created by Ben Rasmussen on 4/9/17.
//  Copyright © 2017 ben. All rights reserved.
//

import Foundation

class Thought {
	var pinID: String
	var posterName: String?
	var text: String
	var timeStamp: String
	
	init(_ pinID: String, _ text: String,_ timeStamp: String) {
		self.pinID = pinID
		self.text = text
		self.timeStamp = timeStamp
	}
}
