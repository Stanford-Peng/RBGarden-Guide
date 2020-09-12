//
//  PlantsVolume.swift
//  RBGarden-Guide
//
//  Created by Stanford on 12/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class PlantsVolume: NSObject, Decodable {
    var allPlants : [PlantData]?
    var links : Links?
    
    private enum CodingKeys: String, CodingKey{
        case allPlants = "data"
        case links
    }
    

}
