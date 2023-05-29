//
//  SearchTableViewCell.swift
//  Project
//
//  Created by CNTT on 4/29/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    //Properties
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var nameSearch: UILabel!
    @IBOutlet weak var daySearch: UILabel!
    @IBOutlet weak var moneySearch: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
