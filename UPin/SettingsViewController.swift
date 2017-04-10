//
//  SettingsViewController.swift
//  uPin
//
//  Created by Ben Rasmussen on 4/9/17.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
	@IBOutlet var txtNickname: UITextField!
	@IBOutlet var tblFavorites: UITableView!
	
	static var favorites: [String] = []
	static let favoritesKey = "favoritesKey"
	
	static let nicknameKey = "nicknameKey"
	static var nickname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		txtNickname.placeholder = SettingsViewController.nickname ?? "anonymous"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	static func loadFavorites() {
		if let favorites = UserDefaults.standard.value(forKey: favoritesKey)  as? [String] {
			SettingsViewController.favorites = favorites
		}
		if let nickname = UserDefaults.standard.string(forKey: nicknameKey) {
			SettingsViewController.nickname = nickname
		}
	}
	
	@IBAction func btnAddFavorite_touchUpInside(sender: UIButton) {
		let alert = UIAlertController(title: "Who would you like to add to your favorites?", message: "", preferredStyle: .alert)
		
		//sets blank placeholder for popup
		alert.addTextField(configurationHandler: { (textField) -> Void in
			textField.text = ""
		})
		
		//Grab the value from the text field, and print it when the user clicks OK.
		alert.addAction(UIAlertAction(title: "add", style: .default, handler: { (action) -> Void in
			let textField = alert.textFields![0] as UITextField
			let newFavorite = textField.text!
			
			SettingsViewController.favorites.append(newFavorite)
			UserDefaults.standard.setValue(SettingsViewController.favorites, forKey: SettingsViewController.favoritesKey)
			
			DispatchQueue.main.async {
				self.tblFavorites.reloadData()
			}
		}))
		
		alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.text == "" {
			SettingsViewController.nickname = nil
			txtNickname.placeholder = "anonymous"
		} else {
			SettingsViewController.nickname = textField.text
			UserDefaults.standard.set(txtNickname.text, forKey: SettingsViewController.nicknameKey)
			txtNickname.text = ""
			txtNickname.placeholder = SettingsViewController.nickname
		}
		
		
		
		return true
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let leaveRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "delete", handler:{action, indexpath in
			SettingsViewController.favorites.remove(at: indexPath.row)
			UserDefaults.standard.setValue(SettingsViewController.favorites, forKey: SettingsViewController.favoritesKey)
			DispatchQueue.main.async {
				self.tblFavorites.reloadData()
			}
		});
		leaveRowAction.backgroundColor = UIColor( red: CGFloat(255/255.0), green: CGFloat(99/255.0), blue: CGFloat(99/255.0), alpha: CGFloat(1.0) )
		
		return [leaveRowAction]
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return SettingsViewController.favorites.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50.0
	}
	
	//runs when the user selects the messages
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		
		// Deselect the row
		tblFavorites.deselectRow(at: indexPath, animated: true)
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Default")
		
		cell.textLabel!.text = SettingsViewController.favorites[indexPath.row]
		
		return cell
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
