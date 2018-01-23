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
    
   
    @IBOutlet weak var datePickerTxt: UITextField!
    @IBOutlet var searchBarMap: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        searchBarMap.delegate = self
    }
    
    // MARK: - add todo list
    @IBAction func addpressed(_ sender: UIBarButtonItem) {
        
        if(textField.text != nil) && textField.text != ""{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            let date = dateFormatter.date(from: datePickerTxt.text!)
            addEvent(title: textField.text!, date: date! as NSDate, completeHandler: {success, eventId in
                if success {
                    
                    let todoData = [kTitle: self.textField.text!,
                                    kDate: self.datePickerTxt.text!,
                                    kDateTimestamp: date!.timeIntervalSince1970,
                                    kEventId: eventId!] as [String : Any]
                    todoList?.insert(todoData, at: 0)
                    self.textField.text = ""
                    self.textField.placeholder = "Add more?"
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    // MARK: - DatePicker
    func createDatePicker(){
        
        datePicker.datePickerMode = .date
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
        // formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
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

