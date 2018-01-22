//
//  TaskManager.swift
//  Assignment0.1
//
//  Created by Jicang Wang on 1/22/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import UIKit

var taskMgr: TaskManager = TaskManager()

struct task{
    var name = "Un-Named"
    var desc = "Un-Described"
}
class TaskManager: NSObject {

    var tasks = task[]
    
    func addTask(name: String, desc:String){
        tasks.apend(task)
    }
}
