//
//  ViewController.swift
//  GeoCalculator
//
//  Created by Jonathan Engelsma on 1/23/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, HistoryTableViewControllerDelegate{

    @IBOutlet weak var p1Lat: DecimalMinusTextField!
    @IBOutlet weak var p1Lng: DecimalMinusTextField!
    @IBOutlet weak var p2Lat: DecimalMinusTextField!
    @IBOutlet weak var p2Lng: DecimalMinusTextField!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    var distanceUnits : String = "Kilometers"
    var bearingUnits : String = "Degrees"
    var entries : [LocationLookup] = []
    

    func selectEntry(entry: LocationLookup){
        p1Lat.text = String(entry.origLat)
        p1Lng.text = String(entry.origLng)
        p2Lat.text = String(entry.destLat)
        p2Lng.text = String(entry.destLng)
        
        doCalculatations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = THEME_COLOR2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doCalculatations()
    {
        guard let p1lt = Double(self.p1Lat.text!), let p1ln = Double(self.p1Lng.text!), let p2lt = Double(self.p2Lat.text!), let p2ln = Double(p2Lng.text!) else {
            return
        }
        let p1 = CLLocation(latitude: p1lt, longitude: p1ln)
        let p2 = CLLocation(latitude: p2lt, longitude: p2ln)
        let distance = p1.distance(from: p2)
        let bearing = p1.bearingToPoint(point: p2)
        
        entries.append(LocationLookup(origLat: p1lt, origLng: p1ln, destLat: p2lt, destLng: p2ln, timestamp: Date()))
        if distanceUnits == "Kilometers" {
            self.distanceLabel.text = "Distance: \((distance / 10.0).rounded() / 100.0) kilometers"
        } else {
            self.distanceLabel.text = "Distance: \((distance * 0.0621371).rounded() / 100.0) miles"
        }
        
        if bearingUnits == "Degrees" {
            self.bearingLabel.text = "Bearing: \((bearing * 100).rounded() / 100.0) degrees."
        } else {
            self.bearingLabel.text = "Bearing: \((bearing * 1777.7777777778).rounded() / 100.0) mils."
        }
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        self.doCalculatations()
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    

    @IBAction func clearButtonPressed(_ sender: UIButton) {
        self.p1Lat.text = ""
        self.p1Lng.text = ""
        self.p2Lat.text = ""
        self.p2Lng.text = ""
        self.distanceLabel.text = "Distance: "
        self.bearingLabel.text = "Bearing: "
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            if let dest = segue.destination as? SettingsViewController {
                dest.dUnits = self.distanceUnits
                dest.bUnits = self.bearingUnits
                dest.delegate = self
            }
        } else if segue.identifier == "historySegue" {
            if let dest = segue.destination as? HistoryTableViewController {
                dest.entries = self.entries
                dest.historyDelegate = self
            }
        }
    }
}

extension ViewController : SettingsViewControllerDelegate
{
    func settingsChanged(distanceUnits: String, bearingUnits: String)
    {
        self.distanceUnits = distanceUnits
        self.bearingUnits = bearingUnits
        self.doCalculatations()
    }
}
