//
//  DatabaseProtocol.swift
//  RBGarden-Guide
//
//  Created by Stanford on 7/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case exhibitionTable
    case exhibition
    case plant
    case plantTable
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    var sort:Bool? {get set}
    var plant:Plant? {get set}
    var exhibition:Exhibition? {get set}
    func onExhibitionTableChange(change: DatabaseChange, exhibitions : [Exhibition])
    func onPlantTableChange(change: DatabaseChange, plants: [Plant])
    func OnExhibitionChange(change: DatabaseChange, exhibition:Exhibition?, exhibitionPlants:[Plant])
    func OnPlantChange(change: DatabaseChange, plant:Plant?)
}

protocol DatabaseProtocol: NSObject {
    
    func cleanup()
    
    func addPlant(scientificName: String, plantName: String, discoverYear: String, family: String) -> Plant
    func addExhibition(exhibitionName: String, exhibitionDescription: String, location_long: Double, location_lat: Double, iconPath: String) -> Exhibition
    func addPlantToExhibition(plant: Plant, exhibition: Exhibition) -> Bool
    
    func deletePlant(plant: Plant)
    func deleteExhibition(exhibition: Exhibition)
    func removePlantFromExhibition(plant: Plant, exhibition: Exhibition)
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    //add for home map to directly fetching without listening
    func fetchAllExhibitions(sort bool:Bool) -> [Exhibition]
    //add for exhibition detail fetching plants
    func fetchExhibitionPlants(exhibitionName:String) -> [Plant]
    
    //add for adding plant on creating exhibition screen
    func fetchAllPlants() -> [Plant]
    
}

//scientificName: String?
//@NSManaged public var plantName: String?
//@NSManaged public var discoverYear: Date?
//@NSManaged public var family: String?
//@NSManaged public var exhibitions: NSSet?

//@NSManaged public var exhibitionName: String?
//@NSManaged public var exhibitionDescription: String?
//@NSManaged public var location_long: Double
//@NSManaged public var location_lat: Double
//@NSManaged public var iconPath: String?
//@NSManaged public var plants: NSSet?
