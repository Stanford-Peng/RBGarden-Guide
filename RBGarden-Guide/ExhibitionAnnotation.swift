//
//  ExhibitionAnnotation.swift
//  RBGarden-Guide
//
//  Created by Stanford on 6/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import MapKit

// refer to https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started
class ExhibitionAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title : String?
    var subtitle: String?
    var icon:String?
    
    init(title:String, subtitle:String, lat:Double, long:Double) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    

    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D, icon:String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.icon = icon
    }
}
