//
//  ExhibitionTableControllerTableViewController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 7/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//
protocol checkNameDelegate:AnyObject {
    func checkExhibitionName() -> Bool
}

import UIKit
import MapKit
class ExhibitionTableController: UITableViewController, DatabaseListener, UISearchResultsUpdating {
    
    
    
    var sort: Bool? = true
    var allExhibitions:[Exhibition] = []
    var filteredExhibitions: [Exhibition] = []
    var listenerType:ListenerType = .exhibitionTable
    
    
    var plant: Plant?
    var exhibition: Exhibition?
    weak var databaseController : DatabaseProtocol?
    weak var homeMapController:HomeMapViewController?
    
    var locationManager = CLLocationManager()

    //add geofencing
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate//repeat addFirstTime(should be removed)
    
//    func addGeofencesForAllExhibitions(){
//        
//        for exhibition in allExhibitions{
//            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: exhibition.location_lat, longitude: exhibition.location_long), radius: RADIUS, identifier: exhibition.exhibitionName!)
//            startMonitoring(region: region)
//        }
//    }
//    
//    //remove all geofencing
//    func stopMonitoringAll() {
//        for region in locationManager.monitoredRegions {
//            locationManager.stopMonitoring(for: region)
//        }
//    }
//    
//    //Customize monitoring function
//    func startMonitoring(region:CLCircularRegion) {
//        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//            displayMessage(title: "Error", message: "Geofencing is not supported on this device!")
//            return
//        }
//        
//        if CLLocationManager.authorizationStatus() != .authorizedAlways && CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
//            displayMessage(title: "Warning", message: "You have to grant RBGGarden-Guide permission to access the device location before using geonotification")
//        }
//        
//        locationManager.startMonitoring(for: region)
//    }
    
    
    //forcefully add annotations when lauching
//    func addFirstTime(){
//        
////        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        databaseController = appDelegate.databaseController
//        allExhibitions = (databaseController?.fetchAllExhibitions(sort: sort!))!
//        addExhibitionAnnotations(exhibitionSet: allExhibitions)
//    }
//    
//    //Add annotation
//    func addExhibitionAnnotations(exhibitionSet:[Exhibition]){
//        //let allExhibitions = databaseController?.fetchAllExhibitions(sort: true)
//        
//        if let annotations = homeMapController?.homeMap.annotations{
//            for annotation in annotations{
//                if let exhibitionAnnotation = annotation as? ExhibitionAnnotation{
//                    homeMapController?.homeMap.removeAnnotation(exhibitionAnnotation)
//                }
//            }
//        }
//        //        let RBGCoordinate = CLLocationCoordinate2D( latitude: -37.830328,longitude: 144.979534)
//        //        let RBGAnnotation : ExhibitionAnnotation = ExhibitionAnnotation(title: "Royal Botanic Garden", subtitle:"Royal Botanic Garden in Melbourne City", coordinate: RBGCoordinate)
//        //        homeMapController?.homeMap.addAnnotation(RBGAnnotation)
//        //        homeMapController?.focusOn(annotation: RBGAnnotation, latitudinalMeters: 1500, longitudinalMeters: 1200)
//        
//        var annotationSet:[ExhibitionAnnotation] = []
//        for exhibition:Exhibition in exhibitionSet {
//            let exhibitionAnnotation = ExhibitionAnnotation(title:exhibition.exhibitionName!, subtitle:exhibition.exhibitionDescription!, coordinate: CLLocationCoordinate2D(latitude: exhibition.location_lat, longitude: exhibition.location_long), icon: exhibition.iconPath!)
//            //exhibitionAnnotation.
//            homeMapController?.homeMap.addAnnotation(exhibitionAnnotation)
//            annotationSet.append(exhibitionAnnotation)
//        }
//        homeMapController?.homeMap.addAnnotations(annotationSet)
//    }
    
    //to initialize and listen to all the exhibitions
    func onExhibitionTableChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        allExhibitions = exhibitions
        //tableView.reloadData()
        //addExhibitionAnnotations(exhibitionSet: allExhibitions)
        //addFirstTime()
        //stopMonitoringAll()
        //addGeofencesForAllExhibitions()
        updateSearchResults(for: navigationItem.searchController!)
        //homeMapController?.homeMap.clear
        //addExhibitionAnnotations(exhibitionSet: filteredExhibitions)
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
        print(sort!)
        databaseController?.removeListener(listener: self)
        databaseController?.addListener(listener: self)
        //addFirstTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseController = appDelegate.databaseController //repeatedly add in addFirst
        //filteredExhibitions = allExhibitions
        //Add search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Heroes"
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented
        definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Confirm to UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchText.count > 0 {
            filteredExhibitions = allExhibitions.filter({ (exhibition: Exhibition) -> Bool in
                guard let name = exhibition.exhibitionName, let exhibitionDescription = exhibition.exhibitionDescription else{
                    return false //hero.name.lowercased().contains(searchText)
                }
                return (name.contains(searchText)||exhibitionDescription.contains(searchText))//make it case sentsitive
            })
        } else {
            filteredExhibitions = allExhibitions
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return filteredExhibitions.count
    }
    
    //Arrange your custom row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exhibitionCell = tableView.dequeueReusableCell(withIdentifier: "exhibitionCell", for: indexPath) as! ExhibitionTableCell
        let exhibition = filteredExhibitions[indexPath.row]
        
        exhibitionCell.name.text = exhibition.exhibitionName
        exhibitionCell.shortDescription.text = exhibition.exhibitionDescription
        exhibitionCell.icon.image = UIImage(named: exhibition.iconPath!)
        // Configure the cell...
        
        return exhibitionCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exhibition = filteredExhibitions[indexPath.row]
        let locationAnnotation:MKAnnotation = ExhibitionAnnotation(title: exhibition.exhibitionName!, subtitle: exhibition.exhibitionDescription!, coordinate: CLLocationCoordinate2D(latitude: exhibition.location_lat, longitude: exhibition.location_long), icon: exhibition.iconPath!)
        //remove in advance so that selected one will not be removed
        homeMapController?.removeAllExhAnnotations()
        homeMapController?.selectedViaTable = true
        homeMapController?.homeMap.addAnnotation(locationAnnotation)// create a new annotation is not a good pratice
        
        //  homeMapController?.focusViaCoordinate(center: CLLocationCoordinate2D(latitude: exhibition.location_lat, longitude: exhibition.location_long), latitudinalMeters: 1000, longitudinalMeters: 1000)
        if let mapNC = homeMapController?.navigationController {
            splitViewController?.showDetailViewController(mapNC, sender: nil)
            
            //splitViewController?.show(mapVC, sender: self)
        }
        homeMapController?.focusOn(annotation: locationAnnotation, latitudinalMeters: 1000,longitudinalMeters: 1000)
    }
    
    
    
    //Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alert = UIAlertController(title: "Alert", message: "Do you want to delete", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (action) in
                self.databaseController?.deleteExhibition(exhibition: self.allExhibitions[indexPath.row])
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            //            var _:(ACTION) -> Void =  { (action) -> Void in
            //                    self.databaseController?.deleteExhibition(exhibition: self.allExhibitions[indexPath.row])
            //            }
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
        //
        if self.count >= length{
            let index = self.index(self.startIndex,offsetBy: length)
            return String(self[..<index])
        }else{
            return self
        }
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
