//
//  ViewController.swift
//  GeoCalculator
//
//  Created by Jonathan Engelsma on 1/23/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class ViewController: UIViewController {

    var entries: [LocationLookup] = [
        LocationLookup(origLat: 90.0, origLng: 0.0, destLat: -90.0, destLng: 0.0, timestamp: Date.distantPast),
        LocationLookup(origLat: -90.0, origLng: 0.0, destLat: 90.0, destLng: 0.0, timestamp: Date.distantFuture)]

    @IBOutlet weak var p1Lat: DecimalMinusTextField!
    @IBOutlet weak var p1Lng: DecimalMinusTextField!
    @IBOutlet weak var p2Lat: DecimalMinusTextField!
    @IBOutlet weak var p2Lng: DecimalMinusTextField!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!

    var distanceUnits: String = "Kilometers"
    var bearingUnits: String = "Degrees"
    fileprivate var ref: FIRDatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = THEME_COLOR2
        self.ref = FIRDatabase.database().reference()
        self.registerForFireBaseUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func registerForFireBaseUpdates() {
        self.ref!.child("history").observe(.value, with: { snapshot in
                                               if let postDict = snapshot.value as? [String: AnyObject] {
                                                   var tmpItems = [LocationLookup]()
                                                   for (_, val) in postDict.enumerated() {
                                                       let entry = val.1 as! Dictionary<String, AnyObject>
                                                       let timestamp = entry["timestamp"] as! String?
                                                       let origLat = entry["origLat"] as! Double?
                                                       let origLng = entry["origLng"] as! Double?
                                                       let destLat = entry["destLat"] as! Double?
                                                       let destLng = entry["destLng"] as! Double?
                                                       tmpItems.append(LocationLookup(origLat: origLat!, origLng: origLng!,
                                                                                      destLat: destLat!, destLng: destLng!,
                                                                                      timestamp: (timestamp?.dateFromISO8601)!))
                                                   }
                                                   self.entries = tmpItems }
                                           })
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
//        commented out locally stored entry array
//        entries.append(LocationLookup(origLat: p1lt, origLng: p1ln, destLat: p2lt, destLng: p2ln, timestamp: Date()))
        // save history to firebase
        let entry = LocationLookup(origLat: p1lt, origLng: p1ln, destLat: p2lt, destLng: p2ln, timestamp: Date())
        let newChild = self.ref?.child("history").childByAutoId()
        newChild?.setValue(self.toDictionary(vals: entry))
    }

    func toDictionary(vals: LocationLookup) -> NSDictionary { return [
        "timestamp": NSString(string: (vals.timestamp.iso8601)),
        "origLat": NSNumber(value: vals.origLat),
        "origLng": NSNumber(value: vals.origLng),
        "destLat": NSNumber(value: vals.destLat),
        "destLng": NSNumber(value: vals.destLng),]
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
                dest.delegate = self
            }
        } else if segue.identifier == "searchSegue" {
            if let dest = segue.destination as? LocationSearchViewController {
                dest.delegate = self
            }
        }
    }
}

extension ViewController: SettingsViewControllerDelegate
{
    func settingsChanged(distanceUnits: String, bearingUnits: String)
    {
        self.distanceUnits = distanceUnits
        self.bearingUnits = bearingUnits
        self.doCalculatations()
    }
}

extension ViewController: HistoryTableViewControllerDelegate
{
    func selectEntry(entry: LocationLookup) {
        self.p1Lat.text = "\(entry.origLat)"
        self.p1Lng.text = "\(entry.origLng)"
        self.p2Lat.text = "\(entry.destLat)"
        self.p2Lng.text = "\(entry.destLng)"
        self.doCalculatations()
    }
}

extension ViewController: LocationSearchDelegate {
    func set(calculationData: LocationLookup)
    {
        self.p1Lat.text = "\(calculationData.origLat)"
        self.p1Lng.text = "\(calculationData.origLng)"
        self.p2Lat.text = "\(calculationData.destLat)"
        self.p2Lng.text = "\(calculationData.destLng)"
        self.doCalculatations()
    }
}

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
            return formatter
        }()
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }
    var short: String {
        return Formatter.short.string(from: self)
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}
extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self) }
}
