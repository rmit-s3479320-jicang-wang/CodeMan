
import UIKit
import MapKit

// event info controller
class EventInfoViewController: UIViewController, EventEditDelegate {

    var event:EventObject = EventObject()
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Event"
        self.refreshRightBarButtonitems()
        self.dayLabel.text = "00"
        self.hoursLabel.text = "00"
        self.minutesLabel.text = "00"
        self.weatherLabel.text = "Weather:"
        self.tempLabel.text = "Temp:"
        self.tempMaxLabel.text = "Temp max:"
        self.tempMinLabel.text = "Temp min:"
        updateEventInfo(event: self.event)
        self.refreshWeather()
        
        self.photoView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target:self, action:#selector(picturePressed))
        self.photoView.gestureRecognizers = [tap]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(countDown),
                                              userInfo: nil,
                                              repeats: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        
    }
    
    // MARK: - refresh weather
    func refreshWeather() {
        queryWeather(latitude: self.event.latitude,
                     longitude: self.event.longitude) { (response) in
                        if response != nil {
                            if (response?.object(forKey: "weather")) != nil{
                                let arr = response?.object(forKey: "weather") as! NSArray
                                let weather = arr.firstObject as! NSDictionary
                                let desc = weather.object(forKey: "description") as! String
                                self.weatherLabel.text = "Weather: "+desc
                                
                                let main = response?.object(forKey: "main") as! NSDictionary
                                var temp = main.object(forKey: "temp") as! Double
                                temp = ceil(temp-273.15)
                                self.tempLabel.text = "Temp: \(temp)°C"
                                var tempMax = main.object(forKey: "temp_max") as! Double
                                tempMax = ceil(tempMax-273.15)
                                self.tempMaxLabel.text = "Temp max: \(tempMax)°C"
                                var tempMin = main.object(forKey: "temp_min") as! Double
                                tempMin = ceil(tempMin-273.15)
                                self.tempMinLabel.text = "Temp min: \(tempMin)°C"
                            }
                            
                        }
        }
    }
    
    // MARK: - picture click
    @objc func picturePressed() {
        if self.photoView.image != nil {
            self.showPreviewPicture(image: self.photoView.image)
        }
    }
    
    func setEvent(event:Event) {
        self.event = EventObject.copyEvent(event: event)!;
    }
    
    func refreshRightBarButtonitems() {
        var str:String
        if self.event.favourite {
            str = "Cancel favourite";
        }else{
            str = "Favourite"
        }
        let item1 = UIBarButtonItem(title: "Edit", style: .plain, target:self, action:#selector(editPressed))
        let item2 = UIBarButtonItem(title: str, style: .plain, target:self, action:#selector(favouritePressed))
        self.navigationItem.rightBarButtonItems = [item1, item2]
    }
    
    @objc func countDown() {
        
        let nowTime = Date().timeIntervalSince1970
        let eventTime = self.event.time
        let timeLag = eventTime - nowTime
        if timeLag <= 0 {
            self.timer.invalidate()
            self.timer = nil
            
            self.dayLabel.text = "00"
            self.hoursLabel.text = "00"
            self.minutesLabel.text = "00"
            return
        }
        let day = floor(timeLag/(3600*24))
        let hour = floor((timeLag - day*3600*24)/3600)
        let minute = floor((timeLag - day*3600*24 - hour*3600)/60)
        
        self.dayLabel.text = String(format: "%02d", Int(day))
        self.hoursLabel.text = String(format: "%02d", Int(hour))
        self.minutesLabel.text = String(format: "%02d", Int(minute))
    }
    
    @objc func editPressed() {
        
        let story = UIStoryboard(name: "Main", bundle:Bundle.main)
        let vc = story.instantiateViewController(withIdentifier: "EventEdit") as! EventEditViewController
        vc.setEvent(event: self.event)
        vc.delegate = self
        self.show(vc, sender: nil)
    }
    
    @objc func favouritePressed() {
        self.event.favourite = !self.event.favourite
        updateEvent(eventObj: self.event)
        self.refreshRightBarButtonitems()
    }
    
    // MARK: - EventEditDelegate
    func updateEventInfo(event: EventObject) {
        self.event = event
        
        self.refreshRightBarButtonitems()
        self.refreshWeather()
        self.dateLabel.text = self.event.dateToString()
        self.titleLabel.text = self.event.title
        self.descLabel.text = self.event.describe
        self.addressLabel.text = self.event.address
        self.photoView.image = self.event.photo
        
        let anno = MKPointAnnotation()
        anno.coordinate = CLLocationCoordinate2DMake(self.event.latitude, self.event.longitude)
        anno.title = self.event.address
        
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: anno.coordinate, span: span)
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(anno)
        self.mapView.selectAnnotation(anno, animated: true)
    }
    
}
