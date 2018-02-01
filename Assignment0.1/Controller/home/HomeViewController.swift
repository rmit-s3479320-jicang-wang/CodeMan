
import UIKit

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var list: Array<Event>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.reloadData()
    }
    
    func reloadData(){
        if self.segmentControl.selectedSegmentIndex == 0 {
            // Future
            if let todo = fetchFutureData(){
                list = todo
            }else{
                list = []
            }
        }else{
            // Past
            if let todo = fetchPastData(){
                list = todo
            }else{
                list = []
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let todo = list{
            return todo.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell
        if let todo = list{
            let event = todo[indexPath.row]
            cell.setCellData(event: event);
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let todo = list{
                
                let event = todo[indexPath.row]
                removeNotify(event: event)
                deleteEvent(event: event)
                self.list?.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let todo = list{
            let event = todo[indexPath.row]
            let story = UIStoryboard(name: "Main", bundle:Bundle.main)
            let vc = story.instantiateViewController(withIdentifier: "EventInfo") as! EventInfoViewController
            vc.setEvent(event: event)
            self.show(vc, sender: nil)
        }
    }
    
    // MARK: - UISegmentControl Changed
    @IBAction func segmentControlChanged(_ segmentControl:UISegmentedControl) {
        self.reloadData()
    }

}
