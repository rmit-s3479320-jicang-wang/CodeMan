//
//  Event.swift
//  Assignment0.1
//
//  Created by zb on 2018/1/23.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit
import EventKit

func addEvent(title: String, date: NSDate, completeHandler:@escaping (_ success: Bool, _ eventId: String?) -> Void){
    
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event, completion: {
        granted, error in
        if (granted) && (error == nil) {
            
            DispatchQueue.main.sync {
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = title
                event.notes = title
                event.startDate = date as Date!
                event.endDate = date.addingTimeInterval(60*5) as Date!
                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(event, span: .thisEvent)
                    completeHandler(true, event.eventIdentifier!)
                }catch{
                    completeHandler(false, nil)
                }
            }
            
        }
    })
}

func removeEvent(eventIds: Array<String>, completeHandler:@escaping (_ success: Bool) -> Void){
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event, completion: {granted, error in
        if (granted) && (error == nil){
            
            DispatchQueue.main.sync {
                do {
                    for eventId in eventIds{
                        let event = eventStore.event(withIdentifier: eventId)
                        try eventStore.remove(event!, span: .thisEvent)
                    }
                    completeHandler(true);
                }catch {
                    completeHandler(false);
                }
            }
            
        }
    });
}

