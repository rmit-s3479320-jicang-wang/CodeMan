
import UIKit
import MapKit
import EventKit
import Photos

// add event controller
class NewFunctionController: UIViewController, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // title
    @IBOutlet weak var textField: UITextField!
    // desc
    @IBOutlet weak var descTextField: UITextField!
    // datetime
    @IBOutlet weak var datePickerTxt: UITextField!
    // photo
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet var searchBarMap: UISearchBar!
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
    
    let datePicker = UIDatePicker()
    
    let event = EventObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        searchBarMap.delegate = self
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
    
    // MARK: - add todo list
    @IBAction func addpressed(_ sender: UIBarButtonItem) {
        
        if textField.text == nil || textField.text == ""{
            showAlert(message: "Please enter the title!")
            return
        }
        if datePickerTxt.text == nil || datePickerTxt.text == ""{
            showAlert(message: "Please enter the datetime!")
            return
        }
        if descTextField.text == nil || descTextField.text == ""{
            showAlert(message: "Please enter the describe!")
            return
        }
        if event.address == ""{
            showAlert(message: "Please enter the address!")
            return
        }
        
        self.event.title = textField.text!
        self.event.describe = descTextField.text!
        self.event.identifier = NSUUID().uuidString
        
        let eve = saveEvent(eventObj: self.event)
        registerNotify(event: eve!)
        self.navigationController?.popViewController(animated: true)
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
        
        datePickerTxt.inputAccessoryView = toolbar
        
        //assigndate picker to text field
        datePickerTxt.inputView = datePicker
        
    }
    
    @objc func donePressed(){
        self.event.time = self.datePicker.date.timeIntervalSince1970
        // formate date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        
        datePickerTxt.text = dateFormatter.string(from: datePicker.date)
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

