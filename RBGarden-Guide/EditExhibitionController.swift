//
//  EditExhibitionController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 13/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class EditExhibitionController: UITableViewController, AddPlantToDetailDelegate {
    
    func addPlant(plant: Plant) {
        addedPlants.append(plant)
        tableView.reloadSections([1], with: .automatic)
    }
    
    
    var selectedExhibition : Exhibition?
    
    var allPlants:[Plant]?
    var basicCell:UITableViewCell?
    
    var addedPlants:[Plant] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        addedPlants = allPlants!
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0{
            return 1
        }
        return addedPlants.count + 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Configure the cell...
        if indexPath.section == 0 {
            basicCell = tableView.dequeueReusableCell(withIdentifier: "exhibitionBasicCell", for: indexPath)
            guard let exhibition = selectedExhibition else {
                return basicCell!
            }
            
            guard let cell = basicCell as? ExhibitionBasicCell else{
                return basicCell!
            }
            
            cell.nameTextfield.text = exhibition.exhibitionName
            
            
            cell.descriptionTextField.text = exhibition.exhibitionDescription
            
            cell.locationTextField.text = "\(exhibition.location_lat),\(exhibition.location_long)"
            return basicCell!
        }
        // Configure the cell...
        if indexPath.section == 1 && indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "addPlantCell", for: indexPath)
            cell.textLabel?.text = "Tap to Add a Plant"
            cell.textLabel?.textColor = .systemBlue
            cell.selectionStyle = .gray
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! plantCellController
        //guard let addedPlants = allPlants else { return cell }
        let plant = addedPlants[indexPath.row - 1]
        
        if let commonName = plant.plantName{
            cell.commonName.text = commonName
        }else{
            cell.commonName.text = "No Common Name"
        }
        
        if let scientificName = plant.scientificName {
            cell.scientificNameLabel.text = scientificName
        }else{
            cell.scientificNameLabel.text = "No Scientific Name"
        }
        
        if let discoverYear = plant.discoverYear{
            cell.discoveredYear.text = discoverYear
        }else{
            cell.discoveredYear.text = "No Year"
        }
        
        return cell
    }
    
    //Arrange your custom row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0{
            return 340.0;
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            return 32.0;
        }
        return 64
    }
    
    //handle tapping add plant cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        if indexPath.section == 1 && indexPath.row == 0{
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "goToPlantTable", sender: self)
        }
        //displayMessage(title: "Party Full", message: "Unable to add more members to party")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addLocation"{
            let controller = segue.destination as! addLocationViewController
            controller.delegate = basicCell as! ExhibitionBasicCell
            
        }
        if segue.identifier == "goToPlantTable"{
            let controller = segue.destination as! allPlantsTableViewController
            //controller.allPlants = self.allPlants
            controller.addPlantToDetailDelegate = self
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 1 && indexPath.row > 0 {
            return true
        }
        return false
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alert = UIAlertController(title: "Alert", message: "Do you want to delete", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (action) in
                self.addedPlants.remove(at: indexPath.row - 1 )
                tableView.reloadSections([1], with: .automatic)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //Save editting content
    
    @IBAction func saveEditing(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let databaseController = appDelegate.databaseController
        let indexPath = IndexPath(row: 0, section: 0)
        let basicCell = tableView.cellForRow(at: indexPath) as! ExhibitionBasicCell
        if addedPlants.count < 3 {
            displayMessage(title: "Attention", message: "You have to make sure there is more than 3 plants in the exhibition!")
            return
        }
        //print(basicCell.nameTextfield.text)
        //print(selectedExhibition?.exhibitionName)
        if basicCell.nameTextfield.text == selectedExhibition?.exhibitionName && basicCell.descriptionTextField.text == selectedExhibition?.exhibitionDescription && (basicCell.locationTextField.text!) == "\(selectedExhibition!.location_lat),\(selectedExhibition!.location_long)"  && convertIntToIcon(segmentInt: basicCell.iconSegment.selectedSegmentIndex) == selectedExhibition?.iconPath && addedPlants == allPlants {
            displayMessage(title: "Attention", message: "You have to make some changes before saving!")
            return
        }
        if basicCell.nameTextfield.text == "" || basicCell.descriptionTextField.text == "" || basicCell.locationTextField.text == ""  {
            displayMessage(title: "No Blank Allowed", message: "Every field needs to be filled in")
            return
        }
        
        if basicCell.nameTextfield.text == nil || basicCell.descriptionTextField.text == nil || basicCell.locationTextField.text == nil  {
            displayMessage(title: "No Blank Allowed", message: "Every field needs to be filled in")
            return
        }
        
        //edit value by value
        if basicCell.nameTextfield.text != selectedExhibition?.exhibitionName{
            if let name = basicCell.nameTextfield.text{ 
                 if let _ = databaseController?.fetchOneExhibitionByName(exhibitionName: name){
                     displayMessage(title: "Alert", message: "This exhibition is already taken!")
                     return
                 }
             }
            selectedExhibition?.exhibitionName = basicCell.nameTextfield.text
        }
        if basicCell.descriptionTextField.text != selectedExhibition?.exhibitionDescription{
            selectedExhibition?.exhibitionDescription = basicCell.descriptionTextField.text
        }
        
        if (basicCell.locationTextField.text!) != "\(selectedExhibition!.location_lat),\(selectedExhibition!.location_long)"{
            print(basicCell.locationTextField.text!)
            print("(\(selectedExhibition!.location_lat),\(selectedExhibition!.location_long))")
            selectedExhibition?.location_lat = basicCell.location_lat!
            selectedExhibition?.location_long = basicCell.location_long!
        }
        
        if convertIntToIcon(segmentInt: basicCell.iconSegment.selectedSegmentIndex) != selectedExhibition?.iconPath{
            selectedExhibition?.iconPath = convertIntToIcon(segmentInt: basicCell.iconSegment.selectedSegmentIndex)
        }
        
        if addedPlants != allPlants{
            selectedExhibition?.plants = NSSet.init(array: addedPlants)
            //            for plant in addedPlants{
            //                if selectedExhibition!.plants!.contains(plant){
            //
            //                }
            //            }
        }

        databaseController?.cleanup()
        navigationController?.popViewController(animated: false)
        navigationController?.popViewController(animated: true)
        //navigationController?.popToRootViewController(animated: true)
        
        //navigationController?.dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: <#T##Bool#>)
        //navigationController?.pushViewController(navigationController!, animated: true)
        //navigationController?.pushViewController(animated: true)
    }
 
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
