//
//  ViewController.swift
//  HaversineCalculator
//
//  Created by Kent Sinclair on 1/25/17.
//  Copyright © 2017 KJAX. All rights reserved.
//


import UIKit
import CoreLocation


// we need to disable the calculate button unless all UITextFields are full
// http://stackoverflow.com/questions/29448185/how-can-i-disable-a-button-until-text-in-all-uitextfields-has-been-entered-in-sw
// 

class ViewController: UIViewController {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    @IBOutlet weak var longitudeP2: UITextField!
    @IBOutlet weak var longitudeP1: UITextField!
    @IBOutlet weak var latitudeP1: UITextField!
    @IBOutlet weak var latitudeP2: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make the keyboard disappear when you click outside of the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleButton(sender: UIButton) {
        if let type = sender.titleLabel?.text {
            switch type {
            case "Calculate":
                let c1 = CLLocation(latitude: Double(latitudeP1.text!)!, longitude: Double(longitudeP1.text!)!)
                let c2 = CLLocation(latitude: Double(latitudeP2.text!)!, longitude: Double(longitudeP2.text!)!)
                
                distanceLabel.text = "Distance: "
                bearingLabel.text = "Bearing: "
                distanceLabel.text?.append(" \(String(format: "%.2f", calcDistance(loc1: c1, loc2: c2))) kilometers")
                bearingLabel.text?.append(" \(String(format: "%.2f", c1.bearingToPoint(point: c2))) degrees")
            case "Clear":
                clearAll()
            default:
                break
            }
        }

    }

    func calcDistance(loc1: CLLocation, loc2: CLLocation) -> Double {
        let distanceInMeters = loc1.distance(from: loc2)
        let distanceInKilometers = distanceInMeters / 1000
        return distanceInKilometers
    }
    
    func clearAll() {
        distanceLabel.text = "Distance: "
        bearingLabel.text = "Bearing: "
        latitudeP1.text = ""
        latitudeP2.text = ""
        longitudeP1.text = ""
        longitudeP2.text = ""
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

