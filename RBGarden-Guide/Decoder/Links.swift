//
//  Links.swift
//  RBGarden-Guide
//
//  Created by Stanford on 12/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class Links: NSObject, Decodable {
    var currentLink : String?
    var firstLink : String?
    var nextLink : String?
    var lastLink : String?
    
    private enum CodingKeys : String, CodingKey{
        case currentLink = "self"
        case firstLink = "first"
        case nextLink = "next"
        case lastLink = "last"
    }

}

