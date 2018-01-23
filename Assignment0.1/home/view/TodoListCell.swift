//
//  TodoListCell.swift
//  Assignment0.1
//
//  Created by zb on 2018/1/23.
//  Copyright © 2018年 RMIT. All rights reserved.
//

import UIKit

class TodoListCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = nil;
        self.timeLabel.text = nil;
    }
    
    public func setCellData(data: Dictionary<String, Any>){
        self.titleLabel.text = data[kTitle] as? String;
        self.timeLabel.text = data[kDate] as? String;
    }
}
