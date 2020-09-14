//
//  HomeMapControllerViewController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 6/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import MapKit
class HomeMapViewController: UIViewController, DatabaseListener {
    
    var listenerType: ListenerType = .exhibitionTable
    
    var sort: Bool?
    
    var plant: Plant?
    
    var exhibition: Exhibition?
    
    //control not remove selected
    var selectedViaTable:Bool = true
    
    func onExhibitionTableChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        allExhibitions = exhibitions
        
        if let oneKey = exhibitionTableController.sort{
            sort = oneKey
        } else {
            sort = true
        }
        //control which screen is from(exhibition table or exhibition detail)
        if !selectedViaTable {
            removeAllExhAnnotations()
        }
        addExhibitionAnnotations(exhibitionSet: allExhibitions!)
        stopMonitoringAll()
        addGeofencesForAllExhibitions()
    }
    
    func onPlantTableChange(change: DatabaseChange, plants: [Plant]) {
        
    }
    
    func OnExhibitionChange(change: DatabaseChange, exhibition: Exhibition?, exhibitionPlants: [Plant]) {
        
    }
    
    func OnPlantChange(change: DatabaseChange, plant: Plant?) {
        
    }
    
    @IBOutlet weak var homeMap: MKMapView!
    weak var databaseController : DatabaseProtocol?
    weak var exhibitionTableController:ExhibitionTableController!
    var tappedView:MKAnnotationView?
    
    var allExhibitions:[Exhibition]?
    var locationManager:CLLocationManager = CLLocationManager()
    //var allExhibitionAnnotation:[ExhibitionAnnotation]?
    let RADIUS:Double = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        let authorisationStatus = CLLocationManager.authorizationStatus()
        if authorisationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        //define accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        //allExhibitions = databaseController?.fetchAllExhibitions(sort: exhibitionTableController.sort!)
        
        let RBGAnnotation  = LocationAnnotation(title: "Royal Botanic Garden", subtitle:"Royal Botanic Garden in Melbourne City", lat: -37.830328,long: 144.979534)
        homeMap.addAnnotation(RBGAnnotation)
        focusOn(annotation: RBGAnnotation, latitudinalMeters: 1500, longitudinalMeters: 1200)
        
        //delegate mapview methods
        homeMap.delegate = self
        
        if let oneKey = exhibitionTableController.sort{
            sort = oneKey
        } else {
            sort = true
        }
        //        let allExhibitions = databaseController?.fetchAllExhibitions(sort: true)
        //        for exhibition:Exhibition in allExhibitions! {
        //            let exhibitionAnnotation = ExhibitionAnnotation(title:exhibition.exhibitionName!, subtitle:exhibition.exhibitionDescription!.cut(length: 35) + "...", coordinate: CLLocationCoordinate2D(latitude: exhibition.location_lat, longitude: exhibition.location_long), icon: exhibition.iconPath!)
        //            //exhibitionAnnotation.
        //            homeMap.addAnnotation(exhibitionAnnotation)
        //            //allExhibitionAnnotation?.append(exhibitionAnnotation)
        //        }
        
        
        //add annotationa and geofences for the first time
        //exhibitionTableController.addFirstTime()
        //exhibitionTableController.addGeofencesForAllExhibitions()
        // Do any additional setup after loading the view.
        
    }
    
    //       func addFirstTime(){
    //
    //    //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //            databaseController = appDelegate.databaseController
    //            allExhibitions = (databaseController?.fetchAllExhibitions(sort: sort!))!
    //            addExhibitionAnnotations(exhibitionSet: allExhibitions)
    //        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    //remove annotations
    func removeAllExhAnnotations(){
        let annotations = homeMap.annotations
        //let annotationsToRemove = annotations.filter{(annotation) throws -> Bool in homeMap.selectedAnnotations.contains({! $0 === annotation})}
        //annotations.contains(where: <#T##(MKAnnotation) throws -> Bool#>)
        //annotations.contain
        for annotation in annotations{
            
            //confusion
            if let exhibitionAnnotation = annotation as? ExhibitionAnnotation{
                // print(annotation.title)
                //                if   homeMap.selectedAnnotations.contains(where: { (annotation) -> Bool in
                //                    return annotation === exhibitionAnnotation
                //
                //                })  {
                //                    continue
                //                }
                
                homeMap.removeAnnotation(exhibitionAnnotation)
            }
        }
    }
    //Add annotation
    func addExhibitionAnnotations(exhibitionSet:[Exhibition]){
        //let allExhibitions = databaseController?.fetchAllExhibitions(sort: true)
        
        
        
        var annotationSet:[ExhibitionAnnotation] = []
        for exhibition:Exhibition in exhibitionSet {
            let exhibitionAnnotation = ExhibitionAnnotation(title:exhibition.exhibitionName!, subtitle:exhibition.exhibitionDescription!, coordinate: CLLocationCoordinate2D(latitude: exhibition.location_lat, longitude: exhibition.location_long), icon: exhibition.iconPath!)
            //exhibitionAnnotation.
            homeMap.addAnnotation(exhibitionAnnotation)
            annotationSet.append(exhibitionAnnotation)
        }
        homeMap.addAnnotations(annotationSet)
    }
    //add geofencing
    func addGeofencesForAllExhibitions(){
        guard let exhibitions = allExhibitions else{return}
        for exhibition in exhibitions{
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: exhibition.location_lat, longitude: exhibition.location_long), radius: RADIUS, identifier: exhibition.exhibitionName!)
            homeMap?.addOverlay(MKCircle(center:CLLocationCoordinate2D(latitude: exhibition.location_lat, longitude: exhibition.location_long), radius: RADIUS))
            startMonitoring(region: region)
            print(region.center)
        }
    }
    
    //remove all geofencing
    func stopMonitoringAll() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        guard let overlays = homeMap?.overlays else { return }
        homeMap?.removeOverlays(overlays)
        
    }
    
    //Customize monitoring function
    func startMonitoring(region:CLCircularRegion) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            displayMessage(title: "Error", message: "Geofencing is not supported on this device!")
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways && CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            displayMessage(title: "Warning", message: "You have to grant RBGGarden-Guide permission to access the device location before using geonotification")
        }
        
        locationManager.startMonitoring(for: region)
    }
    
    //MARK: focus on a single annotation/self-write
    func focusOn(annotation:MKAnnotation, latitudinalMeters: Double, longitudinalMeters: Double){
        if CLLocationManager.authorizationStatus() != .authorizedAlways && CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            displayMessage(title: "Warning", message: "You have to grant RBGGarden-Guide permission to access the device location before using this feature")
            locationManager.requestAlwaysAuthorization()
        }
        homeMap.selectAnnotation(annotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
        homeMap.setRegion(homeMap.regionThatFits(zoomRegion), animated: true)
    }
    
    func focusViaCoordinate(center:CLLocationCoordinate2D, latitudinalMeters: Double, longitudinalMeters: Double){
        if CLLocationManager.authorizationStatus() != .authorizedAlways && CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            displayMessage(title: "Warning", message: "You have to grant RBGGarden-Guide permission to access the device location before using this feature")
            locationManager.requestAlwaysAuthorization()
        }
        let zoomRegion = MKCoordinateRegion(center: center, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
        homeMap.setRegion(homeMap.regionThatFits(zoomRegion), animated: true)
        
    }
    
    //MARK: locate current location
    
    @IBAction func locateSelf(_ sender: Any) {
        homeMap.zoomToUserLocation()
    }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToExhibitionDetail" {
            //switch to remove all
            selectedViaTable = false
            let destination = segue.destination as! ExhibitionDetailController
            destination.exhibitionAnnotation = (tappedView?.annotation as! ExhibitionAnnotation)
        }
    }
    
    
}

// part code retrived from: https://medium.com/macoclock/mapkit-map-pin-and-annotation-5c7d56439c66
//　MKAnnotationView is old while MKMarkerAnnotationView is much better with glyph image and text
extension HomeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        guard let annotation = annotation as? ExhibitionAnnotation else {
            return nil
        }
        
        let identifier = "Exhibition"
        var view : MKMarkerAnnotationView
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            annotationView.annotation = annotation
            view = annotationView
        }else{
            view = MKMarkerAnnotationView(annotation: annotation,
                                          reuseIdentifier: identifier)
            view.canShowCallout = true // need to set handle the callout
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.glyphImage = UIImage(named:annotation.icon!)
        }
        
        return view
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        tappedView = view
        performSegue(withIdentifier: "goToExhibitionDetail", sender: self)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
          let circleRenderer = MKCircleRenderer(overlay: overlay)
          circleRenderer.lineWidth = 1.0
          circleRenderer.strokeColor = .purple
          circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
          return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}

//      annotationView.canShowCallout = true
//
//
//
//            let annotationCast = annotation as! ExhibitionAnnotation
//            annotationView.image = UIImage(named: annotationCast.icon!)
//            return annotationView


//Another way is to move the view into a class and register it im MapView
//class ExhibitionMarkerView: MKMarkerAnnotationView {
//  override var annotation: MKAnnotation? {
//    willSet {
//      // 1
//      guard let exhibitionMarker = newValue as? ExhibitionAnnotation else {
//        return
//      }
//      canShowCallout = true
//      calloutOffset = CGPoint(x: -5, y: 5)
//      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//
//      // 2
//      markerTintColor = artwork.markerTintColor
//      if let letter = artwork.discipline?.first {
//        glyphText = String(letter)
//      }
//    }
//  }
//}

extension MKMapView{
    func zoomToUserLocation() {
        
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        setRegion(region, animated: true)
    }
}

