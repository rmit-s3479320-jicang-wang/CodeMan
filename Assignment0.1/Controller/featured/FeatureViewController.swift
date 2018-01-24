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
        
        self.showAlert(title: "",
                       message: "Do you want to delete the event?",
                       sureHandler: {
                        // delete all
                        todoList?.removeAll()
                        // delete all notify
                        removeAllNotify()
        })
        
    }

}
