
import UIKit

class FeatureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func clickDeleteAllBtn(){
        
        self.showAlert(title: "",
                       message: "Do you want to delete the event?",
                       sureHandler: {
                        // delete all
                        todoList?.removeAll()
                        // delete all notify
                        removeAllNotify()
        })
        
    }

}
