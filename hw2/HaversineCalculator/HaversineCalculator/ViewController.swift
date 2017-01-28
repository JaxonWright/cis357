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
                bearingLabel.text?.append(" \(calcBearing(loc1: c1, loc2: c2)) degrees")
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
    
    func calcBearing(loc1: CLLocation, loc2: CLLocation) -> Double {
        let lat1 = degToRad(degrees: loc1.coordinate.latitude)
        let lon1 = degToRad(degrees: loc1.coordinate.longitude)
        
        let lat2 = degToRad(degrees: loc2.coordinate.latitude)
        let lon2 = degToRad(degrees: loc2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radToDeg(radians: radiansBearing)
    }
    
    func degToRad(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
    func radToDeg(radians: Double) -> Double { return radians * 180.0 / M_PI }
    
    func clearAll() {
        distanceLabel.text = "Distance: "
        bearingLabel.text = "Bearing: "
    }

}

