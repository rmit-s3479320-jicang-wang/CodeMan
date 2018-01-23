//
//  HomeViewController.swift
//  Assignment0.1
//
//  Created by zb on 2018/1/23.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var list: Array<Dictionary<String, Any>>?
    
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
                list = [Dictionary<String, String>]()
            }
        }else{
            // Past
            if let todo = fetchPastData(){
                list = todo
            }else{
                list = [Dictionary<String, String>]()
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
            let data = todo[indexPath.row]
            cell.setCellData(data: data);
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let todo = list{
                let data = todo[indexPath.row]
                let eventId = data[kEventId]
                removeEvent(eventIds: [eventId! as! String], completeHandler: { (success) in
                    if success {
                        let dic = self.list![indexPath.row]
                        var i:Int = 0
                        for tempDic in todoList!{
                            let tempId = tempDic[kEventId] as! String
                            let crrId = dic[kEventId] as! String
                            if tempId == crrId{
                                todoList?.remove(at: i)
                                break
                            }
                            i+=1
                        }
                        
                        self.list?.remove(at: indexPath.row)
                        tableView.reloadData()
                    }
                })
                
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // MARK: - UISegmentControl Changed
    @IBAction func segmentControlChanged(_ segmentControl:UISegmentedControl) {
        self.reloadData()
    }

}
