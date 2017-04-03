//
//  HistoryTableViewCell.swift
//  GeoCalculator
//
//  Created by Kent Sinclair on 3/20/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var origPoint: UILabel!
    @IBOutlet weak var destPoint: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
