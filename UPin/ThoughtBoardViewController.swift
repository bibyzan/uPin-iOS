//
//  ViewController.swift
//  uPin
//
//  Created by Ben Rasmussen on 4/9/17.
//  Copyright © 2017 ben. All rights reserved.
//

import UIKit

class ThoughtBoardViewController: UIViewController, UITableViewDelegate, UITableViewDatasource {
	@IBOutlet var tblThoughts: UITableView!
	@IBOutlet var txtThought: UITextField!
	@IBOutlet var lblTitle: UILabel!
	
	var pin: Pin!
	var thoughts: [Thought] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		
		lblTitle.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func btnPostComment_touchUpInside(sender: UIButton) {
		
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
		tblSettings.deselectRow(at: indexPath, animated: true)
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Default")
		
		
		
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
