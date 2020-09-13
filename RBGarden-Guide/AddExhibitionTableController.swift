//
//  AddExhibitionTableController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 7/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

protocol AddPlantToDetailDelegate:AnyObject {
    var addedPlants:[Plant] { get set }
    func addPlant(plant:Plant)
}


class AddExhibitionTableController: UITableViewController, AddPlantToDetailDelegate{
    
    
    weak var databaseController : DatabaseProtocol?
    let BASIC_SECTION = 0
    let PLANT_SECTION = 1
    var basicCell:UITableViewCell?
    //var allPlants:[Plant]?
    var addedPlants:[Plant] = []
    
    
    //@IBOutlet weak var iconSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        //allPlants = databaseController?.fetchAllPlants()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        allPlants = databaseController?.fetchAllPlants()
//    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == BASIC_SECTION{
            return 1
        }
        return addedPlants.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == BASIC_SECTION {
            basicCell = tableView.dequeueReusableCell(withIdentifier: "exhibitionBasicCell", for: indexPath)
            return basicCell!
        }
        // Configure the cell...
        if indexPath.section == PLANT_SECTION && indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "addPlantCell", for: indexPath)
            cell.textLabel?.text = "Tap to Add a Plant"
            cell.textLabel?.textColor = .systemBlue
            cell.selectionStyle = .gray
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! plantCellController
        
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
        if indexPath.section == PLANT_SECTION && indexPath.row == 0 {
            return 32.0;
        }
        return 64.0
    }
    
    //handle tapping add plant cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == BASIC_SECTION {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        if indexPath.section == PLANT_SECTION && indexPath.row == 0{
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "goToPlantTable", sender: self)
        }
        //displayMessage(title: "Party Full", message: "Unable to add more members to party")
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    
    //AddPlantToDetailDelegate
    func addPlant(plant: Plant) {
        addedPlants.append(plant)
        tableView.reloadSections([1], with: .automatic)
    }
    
    @IBAction func saveExhibitionToDatabase(_ sender: Any) {
        //databaseController?.addExhibition(exhibitionName: <#T##String#>, exhibitionDescription: <#T##String#>, location_long: <#T##Double#>, location_lat: <#T##Double#>, iconPath: <#T##String#>)
        //tableView.cellForRow(at: <#T##IndexPath#>)
        let indexPath = IndexPath(row: 0, section: 0)
        let basicCell = tableView.cellForRow(at: indexPath) as! ExhibitionBasicCell
        if let name = basicCell.nameTextfield.text{
            
            if let _ = databaseController?.fetchOneExhibitionByName(exhibitionName: name){
                displayMessage(title: "Alert", message: "This exhibition is already taken!")
                return
            }
        }
        
        if !(basicCell.nameTextfield.text?.isEmpty ?? false) && !(basicCell.descriptionTextField.text?.isEmpty ?? false) && !(basicCell.locationTextField.text?.isEmpty ?? false) && addedPlants.count >= 3 {
            let exhibitionName = basicCell.nameTextfield.text            
            let exhibitionDescription = basicCell.descriptionTextField.text
            let location_long = basicCell.location_long
            let location_lat = basicCell.location_lat
            let iconSegment = basicCell.iconSegment!
            let iconName = convertIntToIcon(segmentInt: iconSegment.selectedSegmentIndex)
            let addedExhibition = databaseController?.addExhibition(exhibitionName: exhibitionName!, exhibitionDescription: exhibitionDescription!, location_long: location_long!, location_lat: location_lat!, iconPath: iconName)
            for plant in addedPlants{
                let _ = databaseController?.addPlantToExhibition(plant: plant, exhibition: addedExhibition!)
            }
            navigationController?.popViewController(animated: true)
            databaseController?.cleanup()
            displayMessage(title: "Successful", message: "The new exhibition is added!")
            
        } else{
            displayMessage(title: "Empty Required Field", message: "Please fill in the fields first and add at least three plants!")
        }
        
    }
    
    
    
}


extension UITableViewController{
    func convertIntToIcon(segmentInt:Int) -> String{
        switch segmentInt {
        case 0:
            return "fruit-tree"
        case 1:
            return "palm-tree"
        case 2:
            return "sakura"
        case 3:
            return "silver-fern"
        case 4:
            return "willow"
        case 5:
            return "nut"
        case 6:
            return "acacia"
        default:
            return "fruit-tree"
        }
        
    }
}
