//
//  DongTableViewCell.swift
//  Project
//
//  Created by CNTT on 4/27/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class DongTableViewCell: UITableViewCell {

    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    @IBOutlet weak var monthYear: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
