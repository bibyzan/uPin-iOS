//
//  iOSExtensions.swift
//  NeepMVP
//
//  Created by Ben Rasmussen on 10/1/16.
//  Copyright © 2016 Neep. All rights reserved.
//

import Foundation
import UIKit


func wasErrorFromServer(_ view: UIViewController,_ description: String,_ error: Error?)->Bool {
	if let error = error {
		let errorMessage = error.localizedDescription
		
		DispatchQueue.main.async {
			let alert = UIAlertController(title: "Error \(description)", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
			view.present(alert, animated: true, completion: nil)
		}
		return true
	} else {
		return false
	}
}

extension Data {
	var hexString: String {
		return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
	}
}

var indexesOfVisibleSections = [Int]()

extension UITableView {
    
    /// The table section headers that are visible in the table view. (read-only)
    ///
    /// The value of this property is an array containing UITableViewHeaderFooterView objects, each representing a visible cell in the table view.
    ///
    /// Derived From: [http://stackoverflow.com/a/31029960/5191100](http://stackoverflow.com/a/31029960/5191100)
    var visibleSectionHeaders: [UITableViewHeaderFooterView] {
        get {
            var visibleSects = [UITableViewHeaderFooterView]()
            
            indexesOfVisibleSections = getIndexesOfVisibleSections()
            
            for sectionIndex in indexesOfVisibleSections {
                if let sectionHeader = self.headerView(forSection: sectionIndex) {
                    visibleSects.append(sectionHeader)
                }
            }
            
            return visibleSects
        }
    }
    
    fileprivate func getIndexesOfVisibleSections() ->[Int] {
        // Note: We can't just use indexPathsForVisibleRows, since it won't return index paths for empty sections.
        var visibleSectionIndexes = [Int]()
        
        for i in 0 ..< self.numberOfSections {
            var headerRect: CGRect?
            // In plain style, the section headers are floating on the top,
            // so the section header is visible if any part of the section's rect is still visible.
            // In grouped style, the section headers are not floating,
            // so the section header is only visible if it's actual rect is visible.
            if (self.style == .plain) {
                headerRect = self.rect(forSection: i)
            } else {
                headerRect = self.rectForHeader(inSection: i)
            }
            
            if headerRect != nil {
                // The "visible part" of the tableView is based on the content offset and the tableView's size.
                let visiblePartOfTableView: CGRect = CGRect(
                    x: self.contentOffset.x,
                    y: self.contentOffset.y,
                    width: self.bounds.size.width,
                    height: self.bounds.size.height
                )
                
                if (visiblePartOfTableView.intersects(headerRect!)) {
                    visibleSectionIndexes.append(i)
                }
            }
        }
        
        return visibleSectionIndexes
    }
}

extension String {
    func splitWithCharacter(regex: Character)->[String] {
        var splitArr:[String] = []
        var nextStr = ""
        for char in self.characters {
            if char != regex {
                nextStr += String(char)
            } else {
                if nextStr != "" {
                    splitArr.append(nextStr)
                    nextStr = ""
                }
            }
        }
        
        if nextStr != "" {
            splitArr.append(nextStr)
            nextStr = ""
        }
        
        return splitArr
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) years"   }
        if months(from: date)  > 0 { return "\(months(from: date)) months"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) weeks"   }
        if days(from: date)    > 0 { return "\(days(from: date)) days"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hours"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) minutes" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) seconds" }
        return ""
    }
    
    static func getMonth(num: Int)->String {
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        if num <= 12 && num >= 0 {
            return months[num - 1]
        }
        
        return ""
    }
    
    static func compareWith(firstDate: Date, secondDate:Date)->Int {
        if firstDate.compare(secondDate) == ComparisonResult.orderedDescending {
            return 1
        } else if firstDate.compare(secondDate) == ComparisonResult.orderedAscending {
            return 2
        } else {
            return 3
        }
    }
}

enum AppConfiguration {
	case Debug
	case TestFlight
	case AppStore
	
	func description()->String {
		switch self {
		case .Debug:
			return "Debug"
		case .TestFlight:
			return "TestFlight"
		case .AppStore:
			return "AppStore"
		}
	}
}

struct Config {
	// This is private because the use of 'appConfiguration' is preferred.
	private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
	
	// This can be used to add debug statements.
	static var isDebug: Bool {
		return false
	}
	
	static var appConfiguration: AppConfiguration {
		if isDebug {
			return .Debug
		} else if isTestFlight {
			return .TestFlight
		} else {
			return .AppStore
		}
	}
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
