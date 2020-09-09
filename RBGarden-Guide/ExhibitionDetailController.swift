//
//  ExhibitionDetailController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 9/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import MapKit
class ExhibitionDetailController: UITableViewController {
    var exhibitionAnnotation:ExhibitionAnnotation?
    weak var databaseController : DatabaseProtocol?
    var allPlants:[Plant] = []
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    
    @IBOutlet weak var exhibitionDescription: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let eAnnotation = exhibitionAnnotation else{
            return
        }
        iconImage.image = UIImage(named:eAnnotation.icon!)
        name.text = eAnnotation.title
        exhibitionDescription.text = eAnnotation.subtitle
        mapView.addAnnotation(eAnnotation)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        allPlants = databaseController!.fetchExhibitionPlants(exhibitionName: eAnnotation.title!)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return allPlants.count
    }
    
    //Arrange your custom row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64;
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plantCell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath)
        let plant = allPlants[indexPath.row]
        //plantCell.
        
//        exhibitionCell.name.text = exhibition.exhibitionName
//        exhibitionCell.shortDescription.text = exhibition.exhibitionDescription?.cut(length: 100)
//        exhibitionCell.icon.image = UIImage(named: exhibition.iconPath!)
        // Configure the cell...

        return nil
    }
    

}
