//
//  ViewController.swift
//  Assignment0.1
//
//  Created by Jicang Wang on 1/16/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import MapKit
import EventKit

class NewFunctionController: UIViewController, UISearchBarDelegate{
    
    // title
    @IBOutlet weak var textField: UITextField!
    // desc
    @IBOutlet weak var descTextField: UITextField!
    // datetime
    @IBOutlet weak var datePickerTxt: UITextField!
    @IBOutlet var searchBarMap: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    let datePicker = UIDatePicker()
    
    let event = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        searchBarMap.delegate = self
    }
    
    // MARK: - add todo list
    @IBAction func addpressed(_ sender: UIBarButtonItem) {
        
        if textField.text == nil || textField.text == ""{
            showAlert(message: "Please enter the title!")
            return
        }
        if datePickerTxt.text == nil || datePickerTxt.text == ""{
            showAlert(message: "Please enter the datetime!")
            return
        }
        if descTextField.text == nil || descTextField.text == ""{
            showAlert(message: "Please enter the describe!")
            return
        }
        if event.address == ""{
            showAlert(message: "Please enter the address!")
            return
        }
        
        self.event.title = textField.text!
        self.event.desc = descTextField.text!
        
        todoList?.insert(self.event, at: 0)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - DatePicker
    func createDatePicker(){
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = NSDate() as Date
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar buttom item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        datePickerTxt.inputAccessoryView = toolbar
        
        //assigndate picker to text field
        datePickerTxt.inputView = datePicker
        
    }
    
    @objc func donePressed(){
        self.event.timestamp = self.datePicker.date.timeIntervalSince1970
        // formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        datePickerTxt.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let addressName = searchBarMap.text{
            searchBarMap.resignFirstResponder()
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(addressName) { (placemarks:[CLPlacemark]?,error: Error?) in
                if error == nil{
                    let placemark = placemarks?.first
                    let anno = MKPointAnnotation()
                    anno.coordinate = (placemark?.location?.coordinate)!
                    anno.title = addressName
                    self.event.address = addressName
                    self.event.latitude = (placemark?.location?.coordinate.latitude)!
                    self.event.longitude = (placemark?.location?.coordinate.longitude)!
                    
                    let span = MKCoordinateSpanMake(0.075, 0.075)
                    let region = MKCoordinateRegion(center: anno.coordinate, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(anno)
                    self.mapView.selectAnnotation(anno, animated: true)
                    
                }else{
                    print(error?.localizedDescription ?? "error")
                }
            }
        }
    }
}

