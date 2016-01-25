//
//  ViewController.swift
//  Pulse
//
//  Created by sphota on 1/25/16.
//  Copyright © 2016 Lex Levi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, downloadSpeedDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	
	@IBOutlet weak var speedLabel: UILabel!
	
	let options = ["downsp", "upsp"]
	
	override func viewDidLoad() {
		super.viewDidLoad()

		
		DownSpeedManager.sharedInstance.delegate = self
		DownSpeedManager.sharedInstance.beginMonitoring()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(true)
		
		
		speedLabel.text = "Ping..."
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func didUpdateSpeed(sender: AnyObject, withValue: Float) {
		if (Int(withValue) < 1000) {
			speedLabel.text = String(stringInterpolationSegment: Int(withValue)) + " kB/s"
		} else if (Int(withValue) >= 1000) {
			speedLabel.text = String(stringInterpolationSegment: Float(withValue) / 1000.0) + " mB/s"
		}
		
	}
	
	//MARK: - UIPickerView
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return options.count
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 0
	}
	
	//	func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
	//		return nil
	//	}
}

