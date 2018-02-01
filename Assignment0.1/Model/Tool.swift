
import UIKit
import UserNotifications
import Photos

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

let kEventNotifyIdentifierKey = "identifier"

// MARK: - Alert
extension UIViewController{
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(message: String) {
        self.showAlert(title: "", message: message)
    }
    
    func showAlert(title: String, message: String, sureHandler:@escaping () -> Void) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in
            sureHandler()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPhotoActionSheet(cameraHandler:@escaping () -> Void, photoHandler:@escaping () -> Void) {
        
        var msg:String
        if Platform.isSimulator {
            msg = "Please photo!"
        }else{
            msg = "Please camera or photo!"
        }
        let alertController = UIAlertController(title: nil,
                                                message: msg,
                                                preferredStyle: .actionSheet)
        
        var cameraAction:UIAlertAction!
        if !Platform.isSimulator {
            cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                cameraHandler()
            })
        }
        let photoAction = UIAlertAction(title: "Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            photoHandler()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        if cameraAction != nil {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
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

// MARK: - photo auth request
func authorizeToAlbum(completion:@escaping (Bool)->Void) {
    if PHPhotoLibrary.authorizationStatus() != .authorized {
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status == .authorized {
                DispatchQueue.main.async(execute: {
                    completion(true)
                })
            } else {
                DispatchQueue.main.async(execute: {
                    completion(false)
                })
            }
        })
    } else {
        DispatchQueue.main.async(execute: {
            completion(true)
        })
    }
}

// MARK: - camera auth request
func authorizeToCamera(completion:@escaping (Bool)->Void) {
    AVCaptureDevice.requestAccess(for: .video) { (authorized) in
        completion(authorized)
    }
}


