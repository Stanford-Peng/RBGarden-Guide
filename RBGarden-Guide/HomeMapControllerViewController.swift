//
//  HomeMapControllerViewController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 6/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import MapKit
class HomeMapControllerViewController: UIViewController {
    @IBOutlet weak var homeMap: MKMapView!
    
    let RBGCoordinate = CLLocationCoordinate2D( latitude: -37.830328,longitude: 144.979534)
    var locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authorisationStatus = CLLocationManager.authorizationStatus()
        if authorisationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        let RBGAnnotation : ExhibitionAnnotation = ExhibitionAnnotation(title: "Royal Botanic Garden", subtitle:"Royal Botanic Garden in Melbourne City", coordinate: RBGCoordinate)
        homeMap.addAnnotation(RBGAnnotation)
        focusOn(annotation: RBGAnnotation, latitudinalMeters: 1500, longitudinalMeters: 1200)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: focus on a single annotation/self-write
    func focusOn(annotation:MKAnnotation, latitudinalMeters: Double, longitudinalMeters: Double){
        homeMap.selectAnnotation(annotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
        homeMap.setRegion(homeMap.regionThatFits(zoomRegion), animated: true)
    }

    //MARK: locate current location
    
    @IBAction func locateSelf(_ sender: Any) {
        homeMap.zoomToUserLocation()
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

extension MKMapView{
    func zoomToUserLocation() {
      guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
      setRegion(region, animated: true)
    }
}
