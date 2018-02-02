
import UIKit
import MapKit

protocol EventEditDelegate {
    
    func updateEventInfo(event:EventObject)
}

// event edit controller
class EventEditViewController: UIViewController, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var event: EventObject = EventObject()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var searchBarMap: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var cameraPicker: UIImagePickerController!{
        get{
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            return picker
        }
    }
    var photoPicker: UIImagePickerController!{
        get{
            let picker =  UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            return picker
        }
    }
    
    var delegate: EventEditDelegate?
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit"
        
        createDatePicker()
        self.searchBarMap.delegate = self
        
        self.refreshRightBarButtonitems()
        
        self.titleTextField.text = self.event.title
        self.dateTextField.text = self.event.dateToString()
        self.descTextField.text = self.event.describe
        self.searchBarMap.text = self.event.address
        self.datePicker.date = self.event.date()
        self.photoView.image = self.event.photo
        
        let anno = MKPointAnnotation()
        anno.coordinate = CLLocationCoordinate2DMake(self.event.latitude,
                                                     self.event.longitude)
        anno.title = self.event.address
        
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: anno.coordinate, span: span)
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(anno)
        self.mapView.selectAnnotation(anno, animated: true)
        
        self.photoView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target:self, action:#selector(picturePressed))
        self.photoView.gestureRecognizers = [tap]
    }
    
    // MARK: - picture click
    @objc func picturePressed() {
        if self.photoView.image != nil {
            self.showPreviewPicture(image: self.photoView.image)
        }
    }

    func setEvent(event: EventObject) {
        self.event = event;
    }
    
    func refreshRightBarButtonitems() {
        var str:String
        if self.event.favourite {
            str = "Cancel favourite";
        }else{
            str = "Favourite"
        }
        let item1 = UIBarButtonItem(barButtonSystemItem: .save, target:self, action:#selector(savePressed))
        let item2 = UIBarButtonItem(title: str, style: .plain, target:self, action:#selector(favouritePressed))
        self.navigationItem.rightBarButtonItems = [item1, item2]
    }
    
    // MARK: - UIImagePickerControllerDelegate
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.photoView.image = image
        self.event.photo = image
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - add photo
    @IBAction func addPhotoPressed(_ sender: UIBarButtonItem) {
        self.showPhotoActionSheet(cameraHandler: {
            
            authorizeToAlbum(completion: { (authorized) in
                if authorized {
                    self.present(self.cameraPicker, animated: true, completion: nil)
                }else{
                    self.showAlert(message: "Please allow me to open your album!")
                }
            })
        }) {
            authorizeToCamera(completion: { (authorized) in
                if authorized {
                    self.present(self.photoPicker, animated: true, completion: nil)
                }else{
                    self.showAlert(message: "Please allow me to open your camera!")
                }
            })
        }
    }
    
    @objc func savePressed() {
        
        if self.titleTextField.text == nil || self.titleTextField.text == ""{
            showAlert(message: "Please enter the title!")
            return
        }
        if self.dateTextField.text == nil || self.dateTextField.text == ""{
            showAlert(message: "Please enter the datetime!")
            return
        }
        if self.descTextField.text == nil || self.descTextField.text == ""{
            showAlert(message: "Please enter the describe!")
            return
        }
        if self.event.address == ""{
            showAlert(message: "Please enter the address!")
            return
        }
        
        self.event.title = self.titleTextField.text!
        self.event.describe = self.descTextField.text!
        
        let eve = updateEvent(eventObj: self.event)
        // update notify
        registerNotify(event: eve!)
        // goback
        self.delegate?.updateEventInfo(event: self.event)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func favouritePressed() {
        self.event.favourite = !self.event.favourite
        updateEvent(eventObj: self.event)
        self.refreshRightBarButtonitems()
        self.delegate?.updateEventInfo(event: self.event)
    }
    
    // MARK: - DatePicker
    func createDatePicker(){
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = NSDate() as Date
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar buttom item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        
        self.dateTextField.inputAccessoryView = toolbar
        
        //assigndate picker to text field
        self.dateTextField.inputView = datePicker
        
    }
    
    @objc func donePressed(){
        self.event.time = self.datePicker.date.timeIntervalSince1970
        // formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let addressName = searchBarMap.text{
            searchBarMap.resignFirstResponder()
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(addressName) { (placemarks:[CLPlacemark]?,error: Error?) in
                if error == nil{
                    let placemark = placemarks?.first
                    let anno = MKPointAnnotation()
                    anno.coordinate = (placemark?.location?.coordinate)!
                    anno.title = addressName
                    self.event.address = addressName
                    self.event.latitude = (placemark?.location?.coordinate.latitude)!
                    self.event.longitude = (placemark?.location?.coordinate.longitude)!
                    
                    let span = MKCoordinateSpanMake(0.075, 0.075)
                    let region = MKCoordinateRegion(center: anno.coordinate, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(anno)
                    self.mapView.selectAnnotation(anno, animated: true)
                    
                }else{
                    print(error?.localizedDescription ?? "error")
                }
            }
        }
    }
    
}
