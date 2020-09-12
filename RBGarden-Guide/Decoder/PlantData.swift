//
//  PlantData.swift
//  RBGarden-Guide
//
//  Created by Stanford on 12/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class PlantData: NSObject, Decodable {
    
    var plantName : String?
    var scientificName : String?
    
    var family : String?
    var intYear : Int?
    var discoveredYear : Int?
    var imageUrl : String?
    
    private enum CodingKeys: String, CodingKey{
        case plantName = "common_name"
        case scientificName = "scientific_name"
        case family = "family"
        //case intYear = "year"
        case discoveredYear = "year"
        case imageUrl = "image_url"
    }
    
//    init(from decoder:Decoder) throws{
//
//        discoveredYear = String(intYear!)
//    }
//
}
