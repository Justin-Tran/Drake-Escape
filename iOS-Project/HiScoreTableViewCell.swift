//
//  HiScoreTableViewCell.swift
//  iOS-Project
//
//  Created by Rambo Wu on 10/26/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class HiScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameOutlet: UILabel!
    @IBOutlet weak var scoreOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
