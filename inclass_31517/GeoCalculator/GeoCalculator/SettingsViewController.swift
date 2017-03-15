//
//  SettingsViewController.swift
//  GeoCalculator
//
//  Created by Jonathan Engelsma on 2/7/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsChanged(distanceUnits: String, bearingUnits: String)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var bearingUnits: UILabel!
    @IBOutlet weak var distanceUnits: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    var pickerData: [String] = [String]()
    var isDistance = true
    
    var dUnits : String?
    var bUnits: String?
    
    var delegate : SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        self.picker.delegate = self
        self.picker.dataSource = self
        
        let tapDistance = UITapGestureRecognizer(target: self, action: #selector(self.distanceTapped))
        self.distanceUnits.addGestureRecognizer(tapDistance)
        
        let tapBearing = UITapGestureRecognizer(target: self, action: #selector(self.bearingTapped))
        self.bearingUnits.addGestureRecognizer(tapBearing)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hidePicker))
        self.view.addGestureRecognizer(tap)
        
        guard let dStr = self.dUnits, let bStr = bUnits else {
            return
        }
        self.distanceUnits.text = dStr
        self.bearingUnits.text = bStr
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func distanceTapped(sender: UITapGestureRecognizer){
        print("gesture recognizer tapped.")
        self.picker.isHidden = false
        self.pickerData = ["Kilometers", "Miles"]
        self.picker.reloadAllComponents()
        self.picker.isHidden = false
        self.isDistance = true
        
    }
    
    func bearingTapped(sender: UITapGestureRecognizer){
        print("gesture recognizer tapped.2")
        self.pickerData = ["Degrees", "Mils"]
        self.picker.reloadAllComponents()
        self.picker.isHidden = false
        self.isDistance = false
    }
    
    func hidePicker(sender: UITapGestureRecognizer) {
        self.picker.isHidden = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let del = self.delegate {
            del.settingsChanged(distanceUnits: self.dUnits!, bearingUnits: self.bUnits!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    // The number of columns of data
    func numberOfComponents(in: UIPickerView) -> Int
    {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if self.isDistance {
            self.distanceUnits.text = self.pickerData[row]
            self.dUnits = self.pickerData[row]
        } else {
            self.bearingUnits.text = self.pickerData[row]
            self.bUnits = self.pickerData[row]
        }
    }
}
