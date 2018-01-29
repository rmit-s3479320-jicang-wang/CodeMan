

import UIKit
import UserNotifications

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
                                            self.sendNotify()
                                        }else{
                                            print(error?.localizedDescription ?? "error")
                                        }
        })
        
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
    
    func sendNotify() {
        
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
}

