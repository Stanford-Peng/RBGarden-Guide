//
//  EditPlantViewController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 14/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class EditPlantViewController: UIViewController, UITextFieldDelegate {

    var selectedPlant:Plant?
    weak var databaseController : DatabaseProtocol?
    @IBOutlet weak var sciNameLabel: UITextField!
    @IBOutlet weak var commonNameLabel: UITextField!
    @IBOutlet weak var familyNameLabel: UITextField!
    @IBOutlet weak var yearLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sciNameLabel.delegate = self
        commonNameLabel.delegate = self
        familyNameLabel.delegate = self
        yearLabel.delegate = self
        sciNameLabel.text = selectedPlant?.scientificName
        commonNameLabel.text = selectedPlant?.plantName
        familyNameLabel.text = selectedPlant?.family
        yearLabel.text = selectedPlant?.discoverYear
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func savePlantEditing(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let databaseController = appDelegate.databaseController
        if sciNameLabel.text == nil || sciNameLabel.text == ""{
            displayMessage(title: "Alert", message: "Scientiflic name cannot be empty")
            return
        }
        
        if let year = yearLabel.text{
            let date = Date()
            if year.count != 4 || !year.isNumeric {
                displayMessage(title: "Alert", message: "Year should be 4 digits")
                return
            } else if Int(year)! < 0 || Int(year)! > Calendar.current.dateComponents([.year], from: date).year! {
                displayMessage(title: "Alert", message: "Year should be valid")
                return
            }
        }
        
        if selectedPlant?.scientificName == sciNameLabel.text && selectedPlant?.plantName == commonNameLabel.text && selectedPlant?.family == familyNameLabel.text && selectedPlant?.discoverYear == yearLabel.text
        {
            displayMessage(title: "Attention", message: "You have to make some changes before saving")
            return
        }
        if let name = sciNameLabel.text {
            if name != selectedPlant?.scientificName {
                if let _ = databaseController?.fetchOnePlantByName(scientificName: name) {
                    displayMessage(title: "Alert", message: "This Plant Scientific Name already exists in the database")
                    return
                }
                selectedPlant?.scientificName = name
            }
            
            
        }else{
            displayMessage(title: "Alert", message: "Scientiflic name cannot be empty")
        }
        
        if let commonName = commonNameLabel.text {
            if commonName != selectedPlant?.plantName{
                selectedPlant?.plantName = commonName
            }
        }
        
        if let family = familyNameLabel.text{
            if family != selectedPlant?.family{
                selectedPlant?.family = family
            }
        }
        
        if let year = yearLabel.text {
            if year != selectedPlant?.discoverYear{
                selectedPlant?.discoverYear = year
            }
        }
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    //dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension String {
    var isNumeric: Bool {
        //guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
