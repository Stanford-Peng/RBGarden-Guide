//
//  AddExhibitionTableController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 7/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

protocol AddPlantToDetailDelegate:AnyObject {
    func addPlant(plant:Plant)
}



class AddExhibitionTableController: UITableViewController, AddPlantToDetailDelegate{
    
    
    weak var databaseController : DatabaseProtocol?
    let BASIC_SECTION = 0
    let PLANT_SECTION = 1
    var basicCell:UITableViewCell?
    var allPlants:[Plant]?
    var addedPlants:[Plant] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        allPlants = databaseController?.fetchAllPlants()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCellAdded", for: indexPath) as! plantCellController
        let plant = addedPlants[indexPath.row - 1]
        cell.commonName.text = plant.plantName
        cell.scientificName.text = plant.scientificName
        cell.discoveredYear.text = plant.discoverYear
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
        if indexPath.section == PLANT_SECTION{
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "goToPlantTable", sender: self)
        }
        //displayMessage(title: "Party Full", message: "Unable to add more members to party")
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
            controller.allPlants = self.allPlants
            controller.addPlantToDetailDelegate = self
        }
    }
    
    
    func addPlant(plant: Plant) {
        addedPlants.append(plant)
        tableView.reloadSections([1], with: .automatic)
    }
}
