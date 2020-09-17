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
    //var intYear : Int?
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
    
    
    required init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        discoveredYear = try? container.decode(Int.self, forKey: .discoveredYear)
        plantName = try? container.decode(String.self, forKey:.plantName)
        scientificName = try? container.decode(String.self, forKey: .scientificName)
        family = try? container.decode(String.self, forKey: .family)
        //discoveredYear = try?
        //let year = intYear ?? ""
        //discoveredYear = String(year)
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)


    }

}
