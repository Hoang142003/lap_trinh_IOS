//
//  DetailTableViewCell.swift
//  Project
//
//  Created by CNTT on 4/28/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    //Properties
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var nameDetail: UILabel!
    @IBOutlet weak var moneyDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
