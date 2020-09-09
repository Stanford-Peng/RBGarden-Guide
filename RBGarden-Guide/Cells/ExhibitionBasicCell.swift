//
//  ExhibitionBasicCell.swift
//  RBGarden-Guide
//
//  Created by Stanford on 8/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import MapKit
class ExhibitionBasicCell: UITableViewCell,UITextFieldDelegate, addLocationDelegate {

    

    
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var iconSegment: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionTextField.layer.borderWidth = 1
        
        nameTextfield.delegate = self
        locationTextField.delegate = self

        
        //locationTextField.styl
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addExhibitionLocationDelegate(_ viewController: addLocationViewController, pinCoordinate: CLLocationCoordinate2D) {
        locationTextField.text = "\(pinCoordinate.latitude),\(pinCoordinate.longitude)"
        
    }
    
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
