
import UIKit
import UserNotifications

let kEventNotifyIdentifierKey = "identifier"

// MARK: - Alert
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

// MARK: - Notify
func registerNotify(event: Event) {
    let nowTime = Date().timeIntervalSince1970
    if event.time <= nowTime {
        return
    }
    let content = UNMutableNotificationContent()
    content.title = event.title!
    content.subtitle = "address:" + event.address!
    content.body = event.describe!
    content.userInfo = [kEventNotifyIdentifierKey: event.identifier!]
    
    let time = event.time - nowTime
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
    let request = UNNotificationRequest(identifier: event.identifier!,
                                        content: content,
                                        trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

func removeNotify(event: Event) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.identifier!])
    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [event.identifier!])
}

func removeAllNotify() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
}

