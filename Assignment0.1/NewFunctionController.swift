//
//  ViewController.swift
//  Assignment0.1
//
//  Created by Jicang Wang on 1/16/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit
import MapKit
class NewFunctionController: UIViewController, UISearchBarDelegate{
    
    
    
   
    @IBOutlet weak var datePickerTxt: UITextField!
    @IBOutlet weak var searchBarMap: UISearchBar!
    
    @IBOutlet weak var mapView: MKMapView!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createDatePicker()
        searchBarMap.delegate = self
    }
    
    func createDatePicker(){
        
        datePicker.datePickerMode = .date
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarMap.resignFirstResponder()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchBarMap.text!) { (placemarks:[CLPlacemark]?,error: Error?) in
            if error == nil{
                let placemark = placemarks?.first
                let anno = MKPointAnnotation()
                anno.coordinate = (placemark?.location?.coordinate)!
                anno.title = self.searchBarMap.text!
                
                //let span = MKCoordinateSpanMake(0.075, 0.075)
                //let region = MKCoordinateRegion(center: anno.coordinate, span: span)
                
                
                //self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(anno)
                self.mapView.selectAnnotation(anno, animated: true)
                
                
                
            }else{
                print(error?.localizedDescription ?? "error")
            }
            
            }
        
    }
    
    
}


