//
//  ViewController.swift
//  HaversineCalculator
//
//  by Kent Sinclair and Jaxon Wright.
//  Copyright © 2017 KJAX. All rights reserved.
//


import UIKit
import CoreLocation

class ViewController: UIViewController, SettingsViewControllerDelegate{
    
    @IBOutlet weak var distanceLabel: UILabel?
    @IBOutlet weak var bearingLabel: UILabel?

    @IBOutlet weak var longitudeP2: UITextField!
    @IBOutlet weak var longitudeP1: UITextField!
    @IBOutlet weak var latitudeP1: UITextField!
    @IBOutlet weak var latitudeP2: UITextField!
    @IBOutlet weak var calcButton: UIButton!
    
    var delegate: SettingsViewControllerDelegate?
    var distanceUnits: String? = "Kilometers"
    var bearingUnits: String? = "Degrees"

    @IBAction func textChanged(_ sender: UITextField) {
        guard
            let latP1 = latitudeP1.text, !latP1.isEmpty,
            let latP2 = latitudeP2.text, !latP2.isEmpty,
            let lonP1 = longitudeP1.text, !lonP1.isEmpty,
            let lonP2 = longitudeP2.text, !lonP2.isEmpty
            else {
            calcButton.isEnabled = false
            return
        }
        // enable your button if all conditions are met
        calcButton.isEnabled = true

    }

    // Wiring up the cancel button in settings controller to an unwind seque
    // this is not needed...
    @IBAction func unwindToCaclulator(segue: UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()

        distanceLabel?.text = "Distance: "
        bearingLabel?.text = "Bearing: "
        // make the keyboard disappear when you click outside of the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))

        calcButton.isEnabled = false
        
        view.addGestureRecognizer(tap)
        
        let svc = SettingsViewController()
        svc.delegate = self
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

                distanceLabel?.text = "Distance: "
                bearingLabel?.text = "Bearing: "
                distanceLabel?.text?.append(" \(String(format: "%.2f", calcDistance(loc1: c1, loc2: c2))) ")
                if (bearingUnits == "Degrees") {
                    bearingLabel?.text?.append(" \(String(format: "%.2f", c1.bearingToPoint(point: c2))) ")

                } else if (bearingUnits == "Mils") {
                    bearingLabel?.text?.append(" \(String(format: "%.2f", c1.bearingToPoint(point: c2) * 17.777777777778)) ")
                }
                distanceLabel?.text?.append(distanceUnits!)
                bearingLabel?.text?.append(bearingUnits!)
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
        let distanceInMiles = distanceInKilometers * 0.621371
        if (distanceUnits == "Kilometers") {
            return distanceInKilometers
        }
        return distanceInMiles
    }

    func clearAll() {
        distanceLabel?.text = "Distance: "
        bearingLabel?.text = "Bearing: "
        latitudeP1.text = nil
        latitudeP2.text = nil
        longitudeP1.text = nil
        longitudeP2.text = nil
        calcButton.isEnabled = false
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // Implement protocol
    func settingsChanged(distanceUnits: String, bearingUnits: String) {
        self.distanceUnits = distanceUnits
        self.bearingUnits = bearingUnits
        print("SETTINGS CHANGED WAS CALLED")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSettings" {
            if let destVC = segue.destination.childViewControllers[0] as? SettingsViewController {
                destVC.delegate = self
            }
        }
    }
}

//extension ViewController: SettingsViewControllerDelegate {
//    func didFinishTask(sender: SettingsViewController) { // do stuff like updating the UI
//    }
//}


