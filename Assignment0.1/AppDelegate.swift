

import UIKit
import UserNotifications
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound , .alert],
                                    completionHandler: {(granted, error) in
                                        if granted {
                                            print("The notification granted")
                                        }else{
                                            print(error?.localizedDescription ?? "error")
                                        }
        })
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.saveContext();
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext();
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        let identifier = userInfo[kEventNotifyIdentifierKey] as! String
        let event = fetchEvent(identifier: identifier)
        
        let story = UIStoryboard(name: "Main", bundle:Bundle.main)
        let vc = story.instantiateViewController(withIdentifier: "EventInfo") as! EventInfoViewController
        vc.setEvent(event: event!)
        let tabbarController = self.window?.rootViewController as! UITabBarController
        let navigation = tabbarController.selectedViewController as! UINavigationController
        navigation.pushViewController(vc, animated: true)
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.sound, .alert])
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

