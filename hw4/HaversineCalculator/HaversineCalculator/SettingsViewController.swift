//
//  SettingsViewController.swift
//  HaversineCalculator
//
//  Created by Kent Sinclair on 2/14/17.
//  Copyright © 2017 KJAX. All rights reserved.
//

import UIKit


protocol SettingsViewControllerDelegate{
    func settingsChanged(distanceUnits: String, bearingUnits: String)
}

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var bearingPicker: UIPickerView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    

    var delegate: SettingsViewControllerDelegate?
    var unitPickerData: [String] = ["Kilometers"]
    var bearingPickerData: [String] = ["Degrees"]

    @IBAction func CancelPressed(_ sender: UIBarButtonItem) {
        print("Cancel Pressed")
        self.dismiss(animated: true, completion: nil)
    }
    
    // Calls this function when the tap is recognized.
    func dismissPicker() {
        unitPicker.isHidden = true
        bearingPicker.isHidden = true
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("Save button pressed.")
        
        self.delegate?.settingsChanged(distanceUnits: distanceLabel.text!, bearingUnits: bearingLabel.text!)
        self.dismiss(animated: true, completion: nil) // {delegate shit here.})
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("initial unit  \(unitPickerData)")
        print("initial bearing  \(bearingPickerData)")
        unitPicker.isHidden = true
        bearingPicker.isHidden = true
        unitPicker.tag = 1
        bearingPicker.tag = 2
//        self.bearingPicker.delegate = self
//        self.unitPicker.delegate = self

        let tap0: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissPicker))
        view.addGestureRecognizer(tap0)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapUnitPicker))
        tap.numberOfTapsRequired = 1

        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapBearingPicker))
        tap2.numberOfTapsRequired = 1

        distanceLabel.isUserInteractionEnabled = true
        distanceLabel.addGestureRecognizer(tap)
        bearingLabel.isUserInteractionEnabled = true
        bearingLabel.addGestureRecognizer(tap2)

        distanceLabel.text = unitPickerData[0]
        bearingLabel.text = bearingPickerData[0]

        unitPickerData = ["Kilometers", "Miles"]
        bearingPickerData = ["Degrees", "Mils"]
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if self.isBeingDismissed{
            self.delegate?.settingsChanged(distanceUnits: distanceLabel.text!, bearingUnits: bearingLabel.text!)
        }
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return unitPickerData.count
        } else {
            return bearingPickerData.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return unitPickerData[row]
        } else {
            return bearingPickerData[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            distanceLabel.text = unitPickerData[row]
        } else {
            bearingLabel.text = bearingPickerData[row]
        }
    }

    func tapUnitPicker() {
        bearingPicker.isHidden = true
        unitPicker.isHidden = false
        print("tapped on label unit picker!")
    }

    func tapBearingPicker() {
        unitPicker.isHidden = true
        bearingPicker.isHidden = false
        print("tapped on bearing picker!")
    }
}
