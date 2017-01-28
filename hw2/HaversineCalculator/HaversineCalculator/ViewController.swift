//
//  ViewController.swift
//  HaversineCalculator
//
//  Created by Kent Sinclair on 1/25/17.
//  Copyright © 2017 KJAX. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    @IBOutlet weak var longitudeP2: UITextField!
    @IBOutlet weak var longitudeP1: UITextField!
    @IBOutlet weak var latitudeP1: UITextField!
    @IBOutlet weak var latitudeP2: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                
                distanceLabel.text?.append(" \(calcDistance(loc1: c1, loc2: c2)) kilometers")
                bearingLabel.text?.append(" \(c1.bearingToPoint(point: c2)) degrees")
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
    }

}

