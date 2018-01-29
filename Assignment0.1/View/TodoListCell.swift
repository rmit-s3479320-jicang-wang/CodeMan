

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
    
    public func setCellData(event: Event){
        self.titleLabel.text = event.title
        self.timeLabel.text = event.dateToString()
    }
}
