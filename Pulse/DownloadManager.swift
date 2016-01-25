//
//  DownloadManager.swift
//  Pulse
//
//  Created by sphota on 1/25/16.
//  Copyright © 2016 Lex Levi. All rights reserved.


import Foundation

protocol downloadSpeedDelegate {
	func didUpdateSpeed(sender: AnyObject, withValue: Float)
}

class DownSpeedManager: NSObject, NSURLConnectionDataDelegate, NSURLConnectionDelegate {
	
	static let sharedInstance = DownSpeedManager() // Singleton
	
	var receivedData: NSMutableData?
	var start: NSTimer?
	var req: NSURLRequest?
	var conn: NSURLConnection?
	
	var seconds: Float = 0
	var rate: Float = 0
	var receivedLength: Float = 0
	
	var delegate: downloadSpeedDelegate?
	
	var testFileLoc = "http://cachefly.cachefly.net/10mb.test"
	
	func reset() {
		conn = nil
		req = nil
		receivedData = nil
		receivedLength = 0
		seconds = 0
		start?.invalidate()
	}
	
	func setDownloadURL(url: String) {
		self.testFileLoc = url
	}
	
	func beginMonitoring() {
		let url = NSURL(string: self.testFileLoc)
		
		req = NSURLRequest(URL: url!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 60.0)
		
		receivedData = NSMutableData(capacity: 0)
		
		if let request = req {
			conn = NSURLConnection(request: request, delegate: self)
			if conn == nil {
				receivedData = nil
			}
		}
	}
	
	func timer() {
		self.seconds++
		if rate != 0.0 {
			self.delegate?.didUpdateSpeed(self, withValue: rate)
		}
	}
	
	// MARK: - NSURLConnection Delegate
	
	func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
		receivedData?.length = 0
		start = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timer"), userInfo: nil, repeats: true)
	}
	
	func connection(connection: NSURLConnection, didReceiveData data: NSData) {
		receivedData?.appendData(data)
		receivedLength = receivedLength + Float(data.length)
		let kbLength = Float(receivedLength) / 1000 // mB --> kB
		if seconds > 0 {
			rate = (kbLength / seconds)
		}
	}
	
	func connectionDidFinishLoading(connection: NSURLConnection) {
		self.reset()
		self.beginMonitoring()
	}
	
	func connection(connection: NSURLConnection, didFailWithError error: NSError) {
		print(error.localizedDescription + "\n", terminator: "")
		
		self.reset()
		self.beginMonitoring()
	}
}