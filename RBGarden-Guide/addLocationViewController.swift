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
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSaveLocation(_ sender: Any) {
        let coordinate = currentMap.centerCoordinate
        delegate?.addExhibitionLocationDelegate(self, pinCoordinate: coordinate)
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func zoomToUserLocation(_ sender: Any) {
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
