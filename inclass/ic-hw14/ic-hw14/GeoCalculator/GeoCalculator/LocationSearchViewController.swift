//
//  LocationSearchViewController.swift
//  GeoCalculator
//
//  Created by Jonathan Engelsma on 3/28/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import UIKit
import Eureka
import GooglePlacePicker

protocol LocationSearchDelegate {
    func set(calculationData: LocationLookup)
}

class LocationSearchViewController: FormViewController {
    var startPoint:GMSPlace?
    var endPoint:GMSPlace?
    var selectedPoint: Int = 0
    
    var delegate : LocationSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Describe our beautiful eureka form
        form = Section("Calculator Inputs")
            <<< LabelRow () { row in
                row.title = "Start Location"
                row.value = "Tap to search"
                row.tag = "StartLocTag"
                var rules = RuleSet<String>()
                rules.add(rule: RuleClosure(closure: { (loc) -> ValidationError? in
                    if loc == "Tap to search" {
                        return ValidationError(msg: "You must select a location")
                    } else {
                        return nil
                    }
                }))
                row.add(ruleSet:rules)
                }.onCellSelection { cell, row in
                    // crank up Google's place picker when row is selected.
                    let autocompleteController = GMSAutocompleteViewController()
                    autocompleteController.delegate = self
                    self.selectedPoint = 0
                    self.present(autocompleteController, animated: true, completion: nil)
            }
            <<< LabelRow () { row in
                row.title = "End Location"
                row.value = "Tap to search"
                row.tag = "EndLocTag"
                var rules = RuleSet<String>()
                rules.add(rule: RuleClosure(closure: { (loc) -> ValidationError? in
                    if loc == "Tap to search" {
                        return ValidationError(msg: "You must select a location")
                    } else {
                        return nil
                    }
                }))
                row.add(ruleSet:rules)
                }.onCellSelection { cell, row in
                    // crank up Google's place picker when row is selected.
                    let autocompleteController = GMSAutocompleteViewController()
                    autocompleteController.delegate = self
                    self.selectedPoint = 1
                    self.present(autocompleteController, animated: true, completion: nil)
            }
            +++ Section("Calculation Date")
            <<< DateRow(){ row in
                row.title = "Date"
                row.value = Date()
                row.tag = "DateTag"
                row.add(rule: RuleRequired())
            }
        
        let labelRowValidationUpdate : (LabelRow.Cell, LabelRow) -> () = { cell, row in
            if !row.isValid {
                cell.textLabel?.textColor = .red
            } else {
                cell.textLabel?.textColor = .black
            }
        }
        LabelRow.defaultCellUpdate = labelRowValidationUpdate
        LabelRow.defaultOnRowValidationChanged = labelRowValidationUpdate
        
        let cancelButton : UIBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                             style: .plain, target: self,
                                                             action: #selector(LocationSearchViewController.cancelPressed))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let saveButton : UIBarButtonItem = UIBarButtonItem(title: "Save",
                                                           style: .plain, target: self,
                                                           action: #selector(LocationSearchViewController.savePressed))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func cancelPressed()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func savePressed()
    {
        let errors = self.form.validate()
        if errors.count > 0 {
            print("fix ur errors!")
        } else {

            let endDateRow : DateRow! = form.rowBy(tag: "DateTag")
            let endDate = endDateRow.value! as Date

            let p1Lat = (self.startPoint?.coordinate.latitude)!
            let p1Lng = (self.startPoint?.coordinate.longitude)!
            let p2Lat = (self.endPoint?.coordinate.latitude)!
            let p2Lng = (self.endPoint?.coordinate.longitude)!
            
            // return the newly created Journal instance via the delegate
            self.delegate?.set(calculationData: LocationLookup(origLat: p1Lat,
                    origLng: p1Lng,
                    destLat: p2Lat,
                    destLng: p2Lng, timestamp: endDate))
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension LocationSearchViewController: GMSAutocompleteViewControllerDelegate {
    
    public func viewController(_ viewController: GMSAutocompleteViewController,
                               didFailAutocompleteWithError error: Error)
    {
        print(error.localizedDescription)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController,
                        didAutocompleteWith place: GMSPlace)
    {
        if self.selectedPoint == 0 {
            if let row = form.rowBy(tag: "StartLocTag") as? LabelRow {
                row.value = place.name
                row.validate()
                self.startPoint = place
            }
        } else {
            if let row = form.rowBy(tag: "EndLocTag") as? LabelRow {
                row.value = place.name
                row.validate()
                self.endPoint = place
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(viewController: GMSAutocompleteViewController,
                        didFailAutocompleteWithError error: NSError)
    {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
        self.dismiss(animated: true, completion: nil)
        let row: LabelRow? = form.rowBy(tag: "LocTag")
        row?.validate()
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController:
        GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController:
        GMSAutocompleteViewController) 
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

