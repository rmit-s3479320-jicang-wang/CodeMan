
import UIKit

class PicturePreviewController: UIViewController {

    @IBOutlet weak var imageView:UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image
        self.imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target:self, action:#selector(pressed))
        self.imageView.gestureRecognizers = [tap]
    }
    
    @objc func pressed() {
       self.dismiss(animated: false, completion: nil)
    }
}
