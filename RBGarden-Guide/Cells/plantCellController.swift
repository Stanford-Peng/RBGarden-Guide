//
//  plantCell.swift
//  RBGarden-Guide
//
//  Created by Stanford on 10/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class plantCellController: UITableViewCell {

    
    @IBOutlet weak var commonName: UILabel!
    @IBOutlet weak var discoveredYear: UILabel!
    
    @IBOutlet weak var scientificNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
