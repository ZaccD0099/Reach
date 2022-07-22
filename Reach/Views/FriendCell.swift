//
//  TableViewCell.swift
//  Reach
//
//  Created by Zach Davis on 7/21/22.
//

import UIKit

class FriendCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var reachIntervalLabel: UILabel!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
