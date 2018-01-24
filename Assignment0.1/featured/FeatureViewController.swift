//
//  FeatureViewController.swift
//  Assignment0.1
//
//  Created by zb on 2018/1/23.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit

class FeatureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func clickDeleteAllBtn(){
        
        let alertController = UIAlertController(title: "Do you want to delete the event?",
                                                message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            
            // delete all
            todoList?.removeAll()
        }))
        self.present(alertController, animated: true, completion: nil)
    }

}
