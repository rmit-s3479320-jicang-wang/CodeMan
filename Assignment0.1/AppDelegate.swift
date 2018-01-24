//
//  AppDelegate.swift
//  Assignment0.1
//
//  Created by Jicang Wang on 1/16/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let todo = fetchData(){
            todoList = todo
        }else{
            todoList = []
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData(todoList: todoList!)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveData(todoList: todoList!)
    }
}

