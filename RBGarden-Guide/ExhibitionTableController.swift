//
//  ExhibitionTableControllerTableViewController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 7/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class ExhibitionTableController: UITableViewController, DatabaseListener {
    
    var sort: Bool? = true
    var allExhibitions:[Exhibition] = []
    var listenerType:ListenerType = .exhibitionTable
    
    var plant: Plant?
    var exhibition: Exhibition?
    weak var databaseController : DatabaseProtocol?
    
    
    
    //to initialize and listen to all the exhibitions
    func onExhibitionTableChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        allExhibitions = exhibitions
        tableView.reloadData()
    }
    
    func onPlantTableChange(change: DatabaseChange, plants: [Plant]) {
        
    }
    
    func OnExhibitionChange(change: DatabaseChange, exhibition: Exhibition?, exhibitionPlants: [Plant]) {
        
    }
    
    func OnPlantChange(change: DatabaseChange, plant: Plant?) {
        
    }
    
    //to add and remove listener in multicast set
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    //to sort the exhibition alphabeticallly
    
    @IBAction func sortWayToggle(_ sender: Any) {
        if sort == nil {
            sort = true
        } else {
            sort = !sort!
        }
        databaseController?.removeListener(listener: self)
        databaseController?.addListener(listener: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return allExhibitions.count
    }
    
    //Arrange your custom row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exhibitionCell = tableView.dequeueReusableCell(withIdentifier: "exhibitionCell", for: indexPath) as! ExhibitionTableCell
        let exhibition = allExhibitions[indexPath.row]
        
        exhibitionCell.name.text = exhibition.exhibitionName
        exhibitionCell.shortDescription.text = exhibition.exhibitionDescription?.cut(length: 100)
        exhibitionCell.icon.image = UIImage(named: exhibition.iconPath!)
        // Configure the cell...

        return exhibitionCell
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


extension String{
    func cut(length:Int) -> String{
        let index = self.index(self.startIndex,offsetBy: length)
        return String(self[..<index])
    }
    
}


//private func load(fileName: String) -> UIImage? {
//    let fileURL = documentsUrl.appendingPathComponent(fileName)
//    do {
//        let imageData = try Data(contentsOf: fileURL)
//        return UIImage(data: imageData)
//    } catch {
//        print("Error loading image : \(error)")
//    }
//    return nil
//}
