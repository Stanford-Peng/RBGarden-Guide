//
//  addLocationViewController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 9/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import MapKit
protocol addLocationDelegate{
    
    func addExhibitionLocationDelegate(_ viewController : addLocationViewController, pinCoordinate : CLLocationCoordinate2D)
}
class addLocationViewController: UIViewController {

    @IBOutlet weak var currentMap: MKMapView!
    var delegate:addLocationDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let RBGCoordinate = CLLocationCoordinate2D( latitude: -37.830328,longitude: 144.979534)
        let RBGAnnotation : ExhibitionAnnotation = ExhibitionAnnotation(title: "Royal Botanic Garden", subtitle:"Royal Botanic Garden in Melbourne City", coordinate: RBGCoordinate)
        currentMap.addAnnotation(RBGAnnotation)
        currentMap.selectAnnotation(RBGAnnotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: RBGCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1200)
        currentMap.setRegion(currentMap.regionThatFits(zoomRegion), animated: true)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSaveLocation(_ sender: Any) {
        let coordinate = currentMap.centerCoordinate
        delegate?.addExhibitionLocationDelegate(self, pinCoordinate: coordinate)
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func zoomToUserLocation(_ sender: Any) {
        if CLLocationManager.authorizationStatus() != .authorizedAlways && CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
          displayMessage(title: "Warning", message: "You have to grant RBGGarden-Guide permission to access the device location before using this feature")
        }
        currentMap.zoomToUserLocation()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
