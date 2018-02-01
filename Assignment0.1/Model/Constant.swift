
import Foundation
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
