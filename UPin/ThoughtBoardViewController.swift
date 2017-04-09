//
//  ViewController.swift
//  uPin
//
//  Created by Ben Rasmussen on 4/9/17.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit

class ThoughtBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
	@IBOutlet var tblThoughts: UITableView!
	@IBOutlet var txtThought: UITextField!
	@IBOutlet var lblTitle: UILabel!
	@IBOutlet var btnPostThought: UIButton!
	
	var pin: Pin!
	var thoughts: [Thought] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		
		lblTitle.text = "Thought board for: \(pin.title)"
		
		NotificationCenter.default.addObserver(self, selector: #selector(ThoughtBoardViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(ThoughtBoardViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
				tblThoughts.frame = tableSize
				
				moveBottomOfScreenUp(CGFloat(height))
			} else {
				print("...oooor nah")
			}
		}
		
	}
	
	//moves the messenger back down in the screen after the keyboard closes and restarts the timer to time the messenger out and hide it
	func keyboardWillHide(_ notification: Notification) {
		let tableSize = CGRect(x: 0, y: self.view.frame.height - tblThoughts.frame.height, width: self.view.frame.width , height: tblThoughts.frame.height)
		tblThoughts.frame = tableSize
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		txtThought.resignFirstResponder()
		self.view.endEditing(true)
		
		return true
	}
	
	func moveBottomOfScreenUp(_ height: CGFloat) {
		var oldPoint = txtThought.frame.origin
		txtThought.frame.origin = CGPoint(x: oldPoint.x, y: self.view.frame.size.height - height - 40)
		
		oldPoint = btnPostThought.frame.origin
		btnPostThought.frame.origin = CGPoint(x: oldPoint.x, y: self.view.frame.size.height - height - 40)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	@IBAction func btnPostComment_touchUpInside(sender: UIButton) {
		let text = txtThought.text ?? ""
		
		UPinAPI.addThought(with: pin.id!, text) { error in
			if !wasErrorFromServer(self,"Posting Thought",error) {
				self.thoughts.append(Thought(text))
				DispatchQueue.main.async {
					self.tblThoughts.reloadData()
				}
			}
		}
	}
	
	//MARK: UITableViewDelegate methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return thoughts.count
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
		tblThoughts.deselectRow(at: indexPath, animated: true)
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Default")
		
		cell.textLabel!.text = thoughts[indexPath.row].text
		
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
