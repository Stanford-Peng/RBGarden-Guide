//
//  ExhibitionTableCell.swift
//  RBGarden-Guide
//
//  Created by Stanford on 8/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class ExhibitionTableCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var shortDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
