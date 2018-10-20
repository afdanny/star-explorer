//
//  FilmCell.swift
//  starexplorer
//
//  Created by Danny on 20.10.18.
//  Copyright © 2018 AFDanny. All rights reserved.
//

import UIKit

class FilmCell: UITableViewCell {

    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
