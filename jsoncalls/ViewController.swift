//
//  ViewController.swift
//  jsoncalls
//
//  Created by dimarchi on 30/10/2017.
//  Copyright © 2017 dimarchi. All rights reserved.
//
//  Simplistic json call exercise based on example presented
//  at the iOS course I'm currently participating in
//  plus expanded to handle two json calls with UI

import UIKit

class ViewController: UIViewController {
    
    var ipAddress : String?
    var spyData : String?
    
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBAction func getData(_ sender: UIButton) {
        findMyIPAddressFunction()
    }
    
    func notifyMainThreadTextView(txtObject: UITextView, message: String)
    {
        DispatchQueue.main.async() {
            // update UI text field
            txtObject.text = message
        }
    }
    
    func notifyMainThreadLabel(txtObject: UILabel, message: String)
    {
        DispatchQueue.main.async() {
            // update UI label
            txtObject.text = message
        }
    }
    
    func findMyIPAddressFunction()
    {
        // current service in use
        let ipAddress = "https://api.ipify.org?format=json"
        let ipURL = URL(string: ipAddress)
        // The request will have nothing else than URL because nothing
        // is transmitted
        let request = URLRequest(url: ipURL!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let dataTask = session.dataTask(with: request) {
            ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            // 1: Check HTTP Response for successful GET request
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            // 2. Valid HTTP response has been received - connection to target URL
            // has been established
            // It must be now parsed according to rules if response is OK (200)
            if (httpResponse.statusCode == 200)
            {
                // The JSON must be parsed out here and its contents used
                // to fill displayed labels.
                do {
                    let jsonDictionary = try JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.allowFragments)
                        as? [String:AnyObject]
                    let ipAddr = jsonDictionary!["ip"] as! String
                    self.notifyMainThreadLabel(txtObject: self.notificationLabel, message: "IP address found: " + ipAddr)
                    self.findMoreIPdata(ipaddr: ipAddr)
                } catch {
                    print("error parsing json data")
                }
            }
            else {
                print("Error in HTTP Response")
            }
        }
        // start actual asynchronous task
        dataTask.resume()
    }
    
    func findMoreIPdata(ipaddr: String)
    {
        // current service in use
        let findMoreAboutIPaddress = "https://freegeoip.net/json/" + ipaddr
        let findMoreAboutIPurl = URL(string: findMoreAboutIPaddress)
        // The request will have nothing else than URL because nothing
        // is transmitted
        let request = URLRequest(url: findMoreAboutIPurl!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let dataTask = session.dataTask(with: request) {
            ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            // 1: Check HTTP Response for successful GET request
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            // 2. Valid HTTP response has been received - connection to target URL
            // has been established
            // It must be now parsed according to rules if response is OK (200)
            if (httpResponse.statusCode == 200)
            {
                self.notifyMainThreadLabel(txtObject: self.notificationLabel, message: "Second JSON retrieval successful")
                // The JSON must be parsed out here and its contents used
                // to fill displayed labels.
                do {
                    let jsonDictionary = try JSONSerialization.jsonObject(with: receivedData, options: JSONSerialization.ReadingOptions.allowFragments)
                        as? [String:AnyObject]
                    
                    // all key values seen here can be used
                    self.notifyMainThreadTextView(txtObject: self.txtView, message: (jsonDictionary?.description)!)
                } catch {
                    print("error parsing json data")
                }
            }
            else {
                print("Error in HTTP Response")
            }
        }
        // start actual asynchronous task
        dataTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtView.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

