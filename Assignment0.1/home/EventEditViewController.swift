//
//  EventEditViewController.swift
//  Assignment0.1
//
//  Created by zb on 2018/1/24.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit
import MapKit

protocol EventEditDelegate {
    
    func updateEvent(event:Event)
}

class EventEditViewController: UIViewController, UISearchBarDelegate{

    var event: Event = Event()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var searchBarMap: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: EventEditDelegate?
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit"
        
        createDatePicker()
        self.searchBarMap.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target:self, action:#selector(savePressed))
        
        self.titleTextField.text = self.event.title
        self.dateTextField.text = self.event.dateToString()
        self.descTextField.text = self.event.desc
        self.searchBarMap.text = self.event.address
        self.datePicker.date = self.event.date()
        
        let anno = MKPointAnnotation()
        anno.coordinate = CLLocationCoordinate2DMake(self.event.latitude,
                                                     self.event.longitude)
        anno.title = self.event.address
        
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: anno.coordinate, span: span)
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(anno)
        self.mapView.selectAnnotation(anno, animated: true)
    }

    func setEvent(event: Event) {
        self.event = event;
    }
    
    @objc func savePressed() {
        
        if self.titleTextField.text == nil || self.titleTextField.text == ""{
            showAlert(message: "Please enter the title!")
            return
        }
        if self.dateTextField.text == nil || self.dateTextField.text == ""{
            showAlert(message: "Please enter the datetime!")
            return
        }
        if self.descTextField.text == nil || self.descTextField.text == ""{
            showAlert(message: "Please enter the describe!")
            return
        }
        if self.event.address == ""{
            showAlert(message: "Please enter the address!")
            return
        }
        
        self.event.title = self.titleTextField.text!
        self.event.desc = self.descTextField.text!
        
        if let todo = todoList{
            
            var i:Int = 0
            for tempEvent in todo{
                if self.event.identifier == tempEvent.identifier{
                    todoList?[i] = self.event
                    // goback
                    self.delegate?.updateEvent(event: self.event)
                    self.navigationController?.popViewController(animated: true)
                    break
                }
                i+=1
            }
        }
        
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
        
        self.dateTextField.inputAccessoryView = toolbar
        
        //assigndate picker to text field
        self.dateTextField.inputView = datePicker
        
    }
    
    @objc func donePressed(){
        self.event.timestamp = self.datePicker.date.timeIntervalSince1970
        // formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
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
