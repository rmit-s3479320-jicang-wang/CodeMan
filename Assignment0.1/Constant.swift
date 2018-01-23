//
//  Constant.swift
//  Assignment0.1
//
//  Created by Jicang Wang on 1/22/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation

let kTitle = "title"
let kDate = "date"
let kEventId = "eventId"
let kDateTimestamp = "dateTimestamp"

var todoList:Array<Dictionary<String, Any>>?

func saveData(todoList:Array<Dictionary<String, Any>>){
    UserDefaults.standard.set(todoList, forKey: "todolist")
    UserDefaults.standard.synchronize()
}

func fetchData() -> Array<Dictionary<String, Any>>?{
    if let todo = UserDefaults.standard.array(forKey: "todolist") as? Array<Dictionary<String, Any>>{
        return todo
    }
    return nil
}

func fetchFutureData() -> Array<Dictionary<String, Any>>?{
    
    let nowTime = NSDate().timeIntervalSince1970
    let resut = todoList?.filter({ (dic) -> Bool in
        let time = dic[kDateTimestamp] as! TimeInterval
        return time >= nowTime
    })
    return resut
}

func fetchPastData() -> Array<Dictionary<String, Any>>?{
    
    let nowTime = NSDate().timeIntervalSince1970
    let resut = todoList?.filter({ (dic) -> Bool in
        let time = dic[kDateTimestamp] as! TimeInterval
        return time < nowTime
    })
    return resut
}
