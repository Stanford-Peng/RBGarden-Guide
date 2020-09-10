//
//  allPlantsTableViewController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 10/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class allPlantsTableViewController: UITableViewController {
 
    weak var addPlantToDetailDelegate : AddPlantToDetailDelegate?
    var allPlants : [Plant]?
    override func viewDidLoad() {
        super.viewDidLoad()

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
        if section == 0{
            return allPlants!.count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCellWhenAdding", for: indexPath) as! plantCellController
            if allPlants![indexPath.row].plantName == ""{
                cell.commonName.text = "No Common Name"
            }else{
                cell.commonName.text = allPlants![indexPath.row].plantName
            }
        cell.scientificName.text = allPlants![indexPath.row].scientificName
        cell.discoveredYear.text = allPlants![indexPath.row].discoverYear
         //Configure the cell...

        return cell
        } else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantInfo", for: indexPath)
               cell.textLabel?.text = "\(allPlants!.count) plants in the database"
               cell.textLabel?.textColor = .secondaryLabel
               cell.selectionStyle = .none
               // Configure the cell...
        return cell
        }
    }

    //set the height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
        return 64;
        }
        return 42
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plant = allPlants?[indexPath.row]
        addPlantToDetailDelegate?.addPlant(plant: plant!)
        navigationController?.popViewController(animated: false)
      //  homeMapController?.focusViaCoordinate(center: CLLocationCoordinate2D(latitude: exhibition.location_lat, longitude: exhibition.location_long), latitudinalMeters: 1000, longitudinalMeters: 1000)

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
