//
//  LocationAnnotation.swift
//  RBGarden-Guide
//
//  Created by Stanford on 13/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import MapKit
class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(title:String, subtitle: String, lat:Double, long:Double) {
        self.title = title
        self.subtitle = subtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

}
