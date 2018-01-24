//
//  Alert.swift
//  Assignment0.1
//
//  Created by zb on 2018/1/23.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        self.showAlert(title: "", message: message)
    }
    
    func showAlert(title: String, message: String, sureHandler:@escaping () -> Void) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            sureHandler()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

