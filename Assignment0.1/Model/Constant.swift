
import UIKit
import CoreData

// MARK: - Event
extension Event{
    
    public class func initEvent() -> Event {
        return Event(context: appDelegate.persistentContainer.viewContext)
    }
    
    @nonobjc public class func fr() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }
    
    func dateToString() -> String {
        if self.time == 0{
            return ""
        }
        let date:Date = Date(timeIntervalSince1970: self.time)
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm a"
        return format.string(from: date)
    }
    
    func date() -> Date {
        return Date(timeIntervalSince1970: self.time)
    }
    
    func photoImage() -> UIImage {
        return UIImage(data: self.photo!)!;
    }
    
    func setPhotoImage(image: UIImage) {
        let imageData = UIImagePNGRepresentation(image)
        self.photo = imageData
    }
    
}

class EventObject: NSObject {
    public var address: String?
    public var describe: String?
    public var identifier: String?
    public var latitude: Double
    public var longitude: Double
    public var photo: UIImage?
    public var time: Double
    public var title: String?
    
    override init() {
        self.address = ""
        self.describe = ""
        self.identifier = ""
        self.latitude = 0
        self.longitude = 0
        self.photo = nil
        self.time = 0
        self.title = ""
        super.init()
    }
    public class func copyEvent(event: Event) -> EventObject? {
        let eventObj = EventObject()
        eventObj.title = event.title
        eventObj.address = event.address
        eventObj.describe = event.describe
        eventObj.identifier = event.identifier
        eventObj.latitude = event.latitude
        eventObj.longitude = event.longitude
        eventObj.photo = event.photoImage()
        eventObj.time = event.time
        return eventObj
    }
    
    func dateToString() -> String {
        if self.time == 0{
            return ""
        }
        let date:Date = Date(timeIntervalSince1970: self.time)
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm a"
        return format.string(from: date)
    }
    
    func date() -> Date {
        return Date(timeIntervalSince1970: self.time)
    }
}

func saveEvent(eventObj: EventObject) -> Event? {
    let event = Event.initEvent()
    event.address = eventObj.address
    event.describe = eventObj.describe
    event.identifier = eventObj.identifier
    event.latitude = eventObj.latitude
    event.longitude = eventObj.longitude
    event.setPhotoImage(image: eventObj.photo!)
    event.time = eventObj.time
    event.title = eventObj.title
    appDelegate.saveContext()
    return event
}

func updateEvent(eventObj: EventObject) -> Event? {
    if let event = fetchEvent(identifier: eventObj.identifier!) {
        event.address = eventObj.address
        event.describe = eventObj.describe
        event.identifier = eventObj.identifier
        event.latitude = eventObj.latitude
        event.longitude = eventObj.longitude
        event.setPhotoImage(image: eventObj.photo!)
        event.time = eventObj.time
        event.title = eventObj.title
        appDelegate.saveContext()
        return event
    }
    return nil
}

func fetchData() -> Array<Event>?{
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = Event.fr()
    do {
        let fetchedResults = try context.fetch(fetchRequest)
        return fetchedResults
    } catch  {
        fatalError("fetchData fail!")
    }
    return nil
}

func fetchFutureData() -> Array<Event>?{
    
    let nowTime = NSDate().timeIntervalSince1970
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = Event.fr()
    fetchRequest.predicate = NSPredicate(format: "time >= %f", nowTime)
    do {
        let fetchedResults = try context.fetch(fetchRequest)
        return fetchedResults
    } catch  {
        fatalError("fetchFutureData fail!")
    }
    return nil
}

func fetchPastData() -> Array<Event>?{
    
    let nowTime = NSDate().timeIntervalSince1970
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = Event.fr()
    fetchRequest.predicate = NSPredicate(format: "time < %f", nowTime)
    do {
        let fetchedResults = try context.fetch(fetchRequest)
        return fetchedResults
    } catch  {
        fatalError("fetchFutureData fail!")
    }
    return nil
}

func fetchEvent(identifier: String) -> Event? {
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = Event.fr()
    fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
    do {
        let fetchedResults = try context.fetch(fetchRequest)
        return fetchedResults.first
    } catch {
        fatalError("fetchEvent fail!")
    }
    return nil
}

func deleteEvent(event: Event) {
    let context = appDelegate.persistentContainer.viewContext
    context.delete(event)
    appDelegate.saveContext()
}

func deleteAllEvent() {
    let fetchRequest = Event.fr()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
    let store = appDelegate.persistentContainer.persistentStoreCoordinator
    let context = appDelegate.persistentContainer.viewContext
    do {
        try store.execute(deleteRequest, with: context)
    } catch {
        fatalError("deleteAllEvent fail!")
    }
}
