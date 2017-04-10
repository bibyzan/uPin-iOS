//
//  ViewController.swift
//  uPin
//
//  Created by Ben Rasmussen on 4/9/17.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit

class ThotBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
	@IBOutlet var tblThots: UITableView!
	@IBOutlet var txtThot: UITextField!
	@IBOutlet var lblTitle: UILabel!
	@IBOutlet var btnPostThot: UIButton!
	@IBOutlet var lblSender: UILabel!
	
	var pin: Pin!
	var thots: [Thot] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let sender = pin.sender {
			lblSender.text = sender
		} else {
			lblSender.text = "anonymous"
		}
		
		lblTitle.text = "Thot board for: \(pin.title)"
		
		NotificationCenter.default.addObserver(self, selector: #selector(ThotBoardViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ThotBoardViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//moves the messenger up in the screen when the keyboard pops up
	func keyboardWillShow(_ notification: Notification) {
		
		if let userInfo = (notification as NSNotification).userInfo {
			if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
				var height = keyboardSize.height
				if (height == 0 || height == 216) {
					height = 255
				}
				
				let tableSize = CGRect(x: 0, y: 82, width: self.view.frame.width, height: self.view.frame.height - height - 80)
				tblThots.frame = tableSize
				
				moveBottomOfScreenUp(CGFloat(height))
			} else {
				print("...oooor nah")
			}
		}
		
	}
	
	//moves the messenger back down in the screen after the keyboard closes and restarts the timer to time the messenger out and hide it
	func keyboardWillHide(_ notification: Notification) {
		let tableSize = CGRect(x: 0, y: self.view.frame.height - tblThots.frame.height, width: self.view.frame.width , height: tblThots.frame.height)
		tblThots.frame = tableSize
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		txtThot.resignFirstResponder()
		self.view.endEditing(true)
		
		return true
	}
	
	func moveBottomOfScreenUp(_ height: CGFloat) {
		var oldPoint = txtThot.frame.origin
		txtThot.frame.origin = CGPoint(x: oldPoint.x, y: self.view.frame.size.height - height - 40)
		
		oldPoint = btnPostThot.frame.origin
		btnPostThot.frame.origin = CGPoint(x: oldPoint.x, y: self.view.frame.size.height - height - 40)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	@IBAction func btnPostComment_touchUpInside(sender: UIButton) {
		let text = txtThot.text ?? ""
		txtThot.text = ""
		
		UPinAPI.addThot(with: pin.id!, text) { error in
			if !wasErrorFromServer(self,"Posting Thot",error) {
				self.thots.append(Thot(text))
				DispatchQueue.main.async {
					self.tblThots.reloadData()
				}
			}
		}
	}
	
	//MARK: UITableViewDelegate methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return thots.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70.0
	}
	
	//runs when the user selects the messages
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		
		// Deselect the row
		tblThots.deselectRow(at: indexPath, animated: true)
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Default")
		
		cell.textLabel!.text = thots[indexPath.row].text
		
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
