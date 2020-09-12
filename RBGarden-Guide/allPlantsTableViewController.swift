//
//  allPlantsTableViewController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 10/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class allPlantsTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    
 
    weak var addPlantToDetailDelegate : AddPlantToDetailDelegate?
    var allPlants : [Plant]?
    var filteredPlants : [Plant]?
    var fetchedPlantData : [PlantData] = []
    let TREFLE_TOKEN = "YYYaSW1hDis7r1LFWLg0dRg3PRoEMPrmo5ZWvwBwBkQ"
    var isFetchOnline : Bool = false
    //for adding plant
    weak var databaseController : DatabaseProtocol!
    //initialize indicator
    
    var indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //produce a search bar for this screen, refer to week6 lab
        let searchController = UISearchController(searchResultsController: nil)
        //search via api
        searchController.searchBar.delegate = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for card"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        //search locally
        searchController.searchResultsUpdater = self
        
        
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        
        //add indicator
        self.view.addSubview(indicator)
        //populate filteredPlants
        updateSearchResults(for: navigationItem.searchController!)
        
        //add database controller
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 && fetchedPlantData.count == 0{
            return filteredPlants!.count
        }
        else if section == 0 && fetchedPlantData.count > 0{
            return fetchedPlantData.count
            
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! plantCellController
            //var plant : AnyObject?
            if fetchedPlantData.count == 0{
                let plant = filteredPlants![indexPath.row]
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
            }else{
                let plant = fetchedPlantData[indexPath.row]
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
                
                if let discoverYear = plant.discoveredYear{
                    cell.discoveredYear.text = String(discoverYear)
                }else{
                    cell.discoveredYear.text = "No Discover Year"
                }
            }
            
            //cell.scientificName.text = filteredPlants![indexPath.row].scientificName
            //cell.discoveredYear.text = filteredPlants![indexPath.row].discoverYear
            //Configure the cell...
            
            return cell
            
        } else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "plantInfo", for: indexPath)
            
            cell.textLabel?.text = "\(filteredPlants!.count) plants in the database"
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

    //            var scientificName:String?
    //            var plantName:String?
    //            var discoverYear:String?
    //            var family:String?
    //            guard let scientificName = plantData.scientificName else{
    //
    //            }
    //            guard let plantName = plantData.plantName else {
    //
    //            }
    //
    //            guard let discoverYear = String(plantData.discoveredYear) else{
    //
    //            }
    //
    //            guard let family = plantData.family else {
    //
    //            }
    // MARK: -add to database
    func addPlantToDB(plantData:PlantData) -> Plant?{
        var plant:Plant?
        let scientificName = plantData.scientificName ?? ""
        let discoverYear = (plantData.discoveredYear ?? 0) == 0 ? "" : String((plantData.discoveredYear ?? 0))
        let plantName = plantData.plantName ?? ""
        let family = plantData.family ?? ""
        plant = databaseController.addPlant(scientificName : scientificName , plantName : plantName, discoverYear : discoverYear, family : family)
        return plant
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFetchOnline {
            let plantData = fetchedPlantData[indexPath.row]
            if let plant = addPlantToDB(plantData: plantData){
                addPlantToDetailDelegate?.addPlant(plant: plant)
                navigationController?.popViewController(animated: false)
            } else{
                displayMessage(title: "Attention", message: "This plant exist in database or this exhibition! Please go back.")
            }
        }else{
            
            let plant = filteredPlants![indexPath.row]
            if addPlantToDetailDelegate!.addedPlants.contains(plant){
                self.displayMessage(title: "Alert", message: "The selected plant is already added!")
                
            }else{
                addPlantToDetailDelegate?.addPlant(plant: plant)
                navigationController?.popViewController(animated: false)
            }
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        isFetchOnline = false
        if searchText.count > 0 {
            filteredPlants = allPlants!.filter({ (plant: Plant) -> Bool in
                guard let name = plant.plantName, let scientificName = plant.scientificName else{
                return false //hero.name.lowercased().contains(searchText)
                }
                return (name.contains(searchText)||scientificName.contains(searchText))//make it case sentsitive
            })
        } else {
            filteredPlants = allPlants
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Search Bar Delegate(press button)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If there is no text end immediately
        guard let searchText = searchBar.text, searchText.count > 0 else {
            return;
        }
        isFetchOnline = true
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        //filteredPlants?.removeAll()
        fetchedPlantData.removeAll()
        
        //tableView.reloadData()
        
        URLSession.shared.invalidateAndCancel()
        
        requestPlants(plantName: searchText)
    }
    
    func requestPlants(plantName: String) {
        let searchString = "https://trefle.io/api/v1/plants/search?token=\(TREFLE_TOKEN)&q=" + plantName
        print (searchString)
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!) {
            (data, response, error) in
            // Regardless of response end the loading icon from the main thread
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
            if let error = error {
                print(error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let plantsVolume = try decoder.decode(PlantsVolume.self, from: data!)
                if let plantsData = plantsVolume.allPlants {
                    //let plants = try decoder.decode(PlantData.self, from: plantsData)
                    self.fetchedPlantData.append(contentsOf: plantsData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch let err {
                print(err)
            }
        }
        task.resume()
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

extension UIViewController{
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
