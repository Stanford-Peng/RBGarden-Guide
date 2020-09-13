//
//  ExhibitionDetailController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 9/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import MapKit
class ExhibitionDetailController : UIViewController, UITableViewDataSource, UITableViewDelegate, DatabaseListener{
    
    var listenerType: ListenerType = .exhibition
    
    var sort: Bool?
    
    var plant: Plant?
    
    var exhibition: Exhibition?
    
    func onExhibitionTableChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        
    }
    
    func onPlantTableChange(change: DatabaseChange, plants: [Plant]) {
        
    }
    
    func OnExhibitionChange(change: DatabaseChange, exhibition: Exhibition?, exhibitionPlants: [Plant]) {
        self.exhibition = exhibition
        self.allPlants = exhibitionPlants
        plantTableView.reloadData()
        
        
    }
    
    func OnPlantChange(change: DatabaseChange, plant: Plant?) {
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //print(exhibition?.exhibitionName!)
        //exhibition = databaseController!.fetchOneExhibitionByName(exhibitionName: (exhibitionAnnotation?.title)!)
        databaseController?.addListener(listener: self)
        //reload everything
        iconImage.image = UIImage(named:exhibition!.iconPath!)
        name.text = exhibition!.exhibitionName!
        exhibitionDescription.text = exhibition!.exhibitionDescription
        //readd annotation
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        let pin:MKAnnotation = ExhibitionAnnotation(title: exhibition!.exhibitionName!, subtitle: exhibition!.exhibitionDescription!.cut(length: 30) + "...", coordinate: CLLocationCoordinate2D(latitude: exhibition!.location_lat, longitude: exhibition!.location_long))
        
        mapView.addAnnotation(pin)
        mapView.selectAnnotation(pin, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    //customize table data source differently for plants
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plantCell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! plantCellController
        let plant:Plant = allPlants[indexPath.row]
        
        if plant.scientificName != nil && plant.scientificName != ""{
            plantCell.scientificNameLabel.text = plant.scientificName
        }else{
            plantCell.scientificNameLabel.text = "No Scientific Name"
        }
        
        if plant.plantName != nil && plant.plantName != ""{
            plantCell.commonName.text = plant.plantName
        }else{
            plantCell.commonName.text = "No Common Name"
        }
        
        if plant.discoverYear != nil && plant.discoverYear != ""{
            plantCell.discoveredYear.text = plant.discoverYear
        }else{
            plantCell.discoveredYear.text = "No Discover Year"
        }
        
        //plantCell.commonName.text = plant.plantName
        //plantCell.discoveredYear.text = plant.discoverYear
        
        return plantCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlant = allPlants[indexPath.row]
        performSegue(withIdentifier: "goToPlant", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPlant" {
            let plantDetailViewController = segue.destination as! PlantDetailViewController
            plantDetailViewController.selectedPlant = selectedPlant
        }
        if segue.identifier == "editExhibition"{
            let editExhibitionController = segue.destination as! EditExhibitionController
            editExhibitionController.selectedExhibition = exhibition
            editExhibitionController.allPlants = allPlants
        }
    }
    
    //Arrange your custom row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64;
    }
    
    
    var exhibitionAnnotation:ExhibitionAnnotation?
    weak var databaseController : DatabaseProtocol?
    var allPlants:[Plant] = []
    var selectedPlant:Plant?
    //var selectedExhibition:Exhibition?
    //for edit exhibition delegate
    //var addedPlants:[Plant] = []
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var plantTableView: UITableView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var exhibitionDescription: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantTableView.dataSource = self
        plantTableView.delegate = self
        guard let eAnnotation = exhibitionAnnotation else{
            return
        }
        //assign coredata controller
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        exhibition = databaseController!.fetchOneExhibitionByName(exhibitionName: (eAnnotation.title)!)
        
        //        iconImage.image = UIImage(named:exhibition!.iconPath!)
        //        name.text = exhibition!.exhibitionName!
        //        exhibitionDescription.text = exhibition!.exhibitionDescription
        //
        //
        //        //add a new annotation and select it
        //        let pin:MKAnnotation = ExhibitionAnnotation(title: exhibition!.exhibitionName!, subtitle: exhibition!.exhibitionDescription!.cut(length: 30) + "...", coordinate: CLLocationCoordinate2D(latitude: exhibition!.location_lat, longitude: exhibition!.location_long))
        //
        //        mapView.addAnnotation(pin)
        //        mapView.selectAnnotation(pin, animated: true)
        //
        //        let zoomRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        //        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
        
        
        //allPlants = databaseController!.fetchExhibitionPlants(exhibitionName: (exhibition?.exhibitionName)!)
        //addedPlants = allPlants
        
    }
    
    
    
    // MARK: - Table view data source
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //
    //        return allPlants.count
    //    }
    //
    //    //Arrange your custom row height
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 64;
    //    }
    //
    //
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let plantCell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! plantCellController
    //        let plant = allPlants[indexPath.row]
    //        plantCell.scientificName.text = plant.scientificName
    //
    ////        exhibitionCell.name.text = exhibition.exhibitionName
    ////        exhibitionCell.shortDescription.text = exhibition.exhibitionDescription?.cut(length: 100)
    ////        exhibitionCell.icon.image = UIImage(named: exhibition.iconPath!)
    //        // Configure the cell...
    //
    //        return plantCell
    //    }
    
    
}
