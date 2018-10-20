//
//  ResidentCell.swift
//  starexplorer
//
//  Created by Danny on 20.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit

class ResidentCell: UITableViewCell {

    @IBOutlet weak var imageGender: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
