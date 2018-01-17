//
//  ViewController.swift
//  Assignment0.1
//
//  Created by Jicang Wang on 1/16/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

class NewFunctionController: UIViewController {
    
    
    
   
    @IBOutlet weak var datePickerTxt: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createDatePicker()
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
    
}


