//
//  Constant.swift
//  Assignment0.1
//
//  Created by Jicang Wang on 1/22/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
import MapKit

let kTitle = "title"
let kDesc = "desc"
let kDateTimestamp = "dateTimestamp"
let kLon = "longitude"
let kLat = "latitude"
let kAddress = "address"
let kIdentifier = "identifier"

class Event : NSObject{
    var identifier: String
    var title: String
    var desc: String
    var timestamp: TimeInterval
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees
    var address: String
    
    override init() {
        self.identifier = ""
        self.title = ""
        self.desc = ""
        self.timestamp = 0
        self.longitude = 0
        self.latitude = 0
        self.address = ""
        super.init()
    }
    
    func dateToString() -> String {
        if self.timestamp == 0{
            return ""
        }
        let date:Date = Date(timeIntervalSince1970: self.timestamp)
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm a"
        return format.string(from: date)
    }
    
    func date() -> Date {
        return Date(timeIntervalSince1970: self.timestamp)
    }
    
    func day() -> Int {
        let nowTime = Date().timeIntervalSince1970
        return Int(floor((self.timestamp-nowTime)/(60*60*24)))
    }
    
    func hour() -> Int {
        let nowTime = Date().timeIntervalSince1970
        return Int(floor((self.timestamp-nowTime)/(60*60)))
    }
    
    func minute() -> Int {
        let nowTime = Date().timeIntervalSince1970
        return Int(floor((self.timestamp-nowTime)/60.0))
    }
}
var todoList:Array<Event>?

func saveData(todoList:Array<Event>){
    var list : [Dictionary<String , Any>] = [Dictionary<String, Any>]()
    for event in todoList{
        var dic:[String : Any] = [String : Any]()
        dic[kTitle] = event.title
        dic[kDesc] = event.desc
        dic[kDateTimestamp] = event.timestamp
        dic[kLon] = event.longitude
        dic[kLat] = event.latitude
        dic[kAddress] = event.address
        dic[kIdentifier] = event.identifier
        list.append(dic)
    }
    UserDefaults.standard.set(list, forKey: "todolist")
    UserDefaults.standard.synchronize()
}

func fetchData() -> Array<Event>?{
    if let todo = UserDefaults.standard.array(forKey: "todolist") as? Array<Dictionary<String, Any>>{
        var arr:Array<Event> = []
        for dic in todo{
            let event = Event()
            event.title = dic[kTitle] as! String
            event.desc = dic[kDesc] as! String
            event.timestamp = dic[kDateTimestamp] as! TimeInterval
            event.longitude = dic[kLon] as! CLLocationDegrees
            event.latitude = dic[kLat] as! CLLocationDegrees
            event.address = dic[kAddress] as! String
            event.identifier = dic[kIdentifier] as! String
            arr.append(event)
        }
        return arr
    }
    return nil
}

func fetchFutureData() -> Array<Event>?{
    
    let nowTime = NSDate().timeIntervalSince1970
    let resut = todoList?.filter({ (event) -> Bool in
        let time = event.timestamp
        return time >= nowTime
    })
    return resut
}

func fetchPastData() -> Array<Event>?{
    
    let nowTime = NSDate().timeIntervalSince1970
    let resut = todoList?.filter({ (event) -> Bool in
        let time = event.timestamp
        return time < nowTime
    })
    return resut
}
