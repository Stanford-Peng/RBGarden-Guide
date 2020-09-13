//
//  CoreDataController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 7/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import CoreData
//Reference: FIT5140 Lab Material
class CoreDataController: NSObject,NSFetchedResultsControllerDelegate, DatabaseProtocol {

    //Listener and persistent container
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer:NSPersistentContainer
    
    // Fetched Results Controllers
    var allPlantsFetchedResultsController: NSFetchedResultsController<Plant>?
    var exhibitionPlantsFetchedResultsController: NSFetchedResultsController<Plant>?
    var allExhibitionsFetchedResultsController: NSFetchedResultsController<Exhibition>?
    var singleExhibitionController:NSFetchedResultsController<Exhibition>?
    var singlePlantController:NSFetchedResultsController<Plant>?
    
    var exhibitionTableSort:Bool = true
    
    override init() {
        // Load the Core Data Stack
        persistentContainer = NSPersistentContainer(name: "RBGModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        super.init()
        if fetchAllExhibitions(sort: exhibitionTableSort).count == 0 {
            createDefaultEntries()
        }
    }
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
    }
    
    func cleanup() {
        saveContext()
    }
    
    func addPlant(scientificName: String, plantName: String, discoverYear: String, family: String, imageUrl:String) -> Plant? {
        var plant : Plant?
        if fetchOnePlantByName(scientificName: scientificName) == nil{
            plant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: persistentContainer.viewContext) as? Plant
            plant?.scientificName = scientificName
            plant?.plantName = plantName
            plant?.discoverYear = discoverYear
            plant?.family = family
            plant?.imageUrl = imageUrl
        }
        return plant
    }
    
    func addExhibition(exhibitionName: String, exhibitionDescription: String, location_long: Double, location_lat: Double, iconPath: String) -> Exhibition? {
        var exhibition : Exhibition?
        if fetchOneExhibitionByName(exhibitionName: exhibitionName) ==  nil{
            exhibition = NSEntityDescription.insertNewObject(forEntityName: "Exhibition", into: persistentContainer.viewContext) as? Exhibition
            exhibition!.exhibitionName = exhibitionName
            exhibition!.exhibitionDescription = exhibitionDescription
            exhibition!.location_lat = location_lat
            exhibition!.location_long = location_long
            exhibition!.iconPath = iconPath
        }
        return exhibition
    }
    
    func addPlantToExhibition(plant: Plant, exhibition: Exhibition) -> Bool {
        guard let plants = exhibition.plants, plants.contains(plant) == false else {
            return false
        }
        exhibition.addToPlants(plant)
        return true
        
    }
    
    func deletePlant(plant: Plant) {
        persistentContainer.viewContext.delete(plant)
    }
    
    func deleteExhibition(exhibition: Exhibition) {
        persistentContainer.viewContext.delete(exhibition)
    }
    
    func removePlantFromExhibition(plant: Plant, exhibition: Exhibition) {
        exhibition.removeFromPlants(plant)
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        if listener.listenerType == .exhibition || listener.listenerType == .all{
            //            listener.onExhibitionChange(change: .update, exhibitionPlants: fetchExhibitionPlants(), exhibition: Exhibition)
            
            listener.OnExhibitionChange(change: .update, exhibition: fetchOneExhibitionByName(exhibitionName: listener.exhibition!.exhibitionName!), exhibitionPlants: fetchExhibitionPlants(exhibitionName: (listener.exhibition?.exhibitionName)!))
            
        }
        
        if listener.listenerType == .exhibitionTable || listener.listenerType == .all{
            listener.onExhibitionTableChange(change: .update, exhibitions: fetchAllExhibitions(sort:listener.sort!))
        }
        
        if listener.listenerType == .plant || listener.listenerType == .all{
            listener.OnPlantChange(change: .update, plant: fetchOnePlantByName(scientificName: listener.plant!.scientificName!))
        }
        
        if listener.listenerType == .plantTable || listener.listenerType == .all{
            listener.onPlantTableChange(change: .update, plants: fetchAllPlants())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func fetchAllPlants() -> [Plant] {
        // If results controller not currently initialized
        if allPlantsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "plantName", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            // Initialize Results Controller
            allPlantsFetchedResultsController =
                NSFetchedResultsController<Plant>(fetchRequest:
                    fetchRequest, managedObjectContext: persistentContainer.viewContext,
                                  sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            allPlantsFetchedResultsController?.delegate = self
            do {
                try allPlantsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        var plants = [Plant]()
        if allPlantsFetchedResultsController?.fetchedObjects != nil {
            plants = (allPlantsFetchedResultsController?.fetchedObjects)!
        }
        return plants
    }
    
    
    func fetchExhibitionPlants(exhibitionName:String) -> [Plant] {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: "plantName", ascending: true)
        print(exhibitionName)
        let predicate = NSPredicate(format: "ANY exhibitions.exhibitionName == %@", exhibitionName)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        fetchRequest.predicate = predicate
        
        exhibitionPlantsFetchedResultsController =
            NSFetchedResultsController<Plant>(fetchRequest: fetchRequest,
                                              managedObjectContext: persistentContainer.viewContext,
                                              sectionNameKeyPath: nil, cacheName: nil)
        exhibitionPlantsFetchedResultsController?.delegate = self
        do {
            try exhibitionPlantsFetchedResultsController?.performFetch()
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        
        var plants = [Plant]()
        if exhibitionPlantsFetchedResultsController?.fetchedObjects != nil {
            plants = (exhibitionPlantsFetchedResultsController?.fetchedObjects)!
        }
        return plants
    }
    
    func fetchAllExhibitions(sort bool:Bool) -> [Exhibition]{
        if allExhibitionsFetchedResultsController == nil || bool != exhibitionTableSort {
            exhibitionTableSort = bool
            let fetchRequest:NSFetchRequest<Exhibition> = Exhibition.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "exhibitionName", ascending: exhibitionTableSort)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            // Initialize Results Controller
            
            allExhibitionsFetchedResultsController =
                NSFetchedResultsController<Exhibition>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            // Set this class to be the results delegate
            allExhibitionsFetchedResultsController?.delegate = self
            do {
                try allExhibitionsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        
        var exhibitions = [Exhibition]()
        if allExhibitionsFetchedResultsController?.fetchedObjects != nil {
            exhibitions = (allExhibitionsFetchedResultsController?.fetchedObjects)!
        }
        return exhibitions
    }
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allExhibitionsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .exhibitionTable || listener.listenerType == .all {
                    listener.onExhibitionTableChange(change: .update, exhibitions: fetchAllExhibitions(sort: listener.sort!))
                }
            }
        } else if controller == allPlantsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .plantTable || listener.listenerType == .all {
                    listener.onPlantTableChange(change: .update, plants: fetchAllPlants())
                }
            }
        }
        else if controller == singleExhibitionController{
            listeners.invoke { (listener) in
                if listener.listenerType == .exhibition || listener.listenerType == .all {
                     listener.OnExhibitionChange(change: .update, exhibition: fetchOneExhibitionByName(exhibitionName: listener.exhibition!.exhibitionName!), exhibitionPlants: fetchExhibitionPlants(exhibitionName: (listener.exhibition?.exhibitionName)!))
                }
            }
            
        }
    }
    
    // reference: https://medium.com/@aliakhtar_16369/mastering-in-coredata-part-9-nsfetchrequest-d9ad991355d9
    func fetchOneExhibitionByName(exhibitionName:String) -> Exhibition?{
        let fetchRequest:NSFetchRequest<Exhibition> = Exhibition.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: "exhibitionName", ascending: exhibitionTableSort)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        let predicate = NSPredicate(format: "exhibitionName == %@", exhibitionName)
        fetchRequest.predicate = predicate
        
        singleExhibitionController = NSFetchedResultsController<Exhibition>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        singleExhibitionController?.delegate = self
        do {
            try singleExhibitionController?.performFetch()
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        var exhibition : Exhibition?
        if (singleExhibitionController?.fetchedObjects)!.count > 0{
            exhibition = (singleExhibitionController?.fetchedObjects)![0]
        }
        
        return exhibition
    }
    
    func fetchOnePlantByName(scientificName:String) -> Plant?{
        let fetchRequest:NSFetchRequest<Plant> = Plant.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: "plantName", ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        let predicate = NSPredicate(format: "scientificName == %@", scientificName)
        fetchRequest.predicate = predicate
        
        singlePlantController = NSFetchedResultsController<Plant>(fetchRequest:fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        singlePlantController?.delegate = self
        do {
            try singlePlantController?.performFetch()
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        var plant : Plant?
        if (singlePlantController?.fetchedObjects)!.count > 0{
            plant = (singlePlantController?.fetchedObjects)![0]
        }
        return plant
    }
    
    func createDefaultEntries(){
        let exhibition1 = addExhibition(exhibitionName: "Arid Garden", exhibitionDescription: "The Arid Garden displays an extraordinary assortment of cacti, aloes, agaves and bromeliads that have unique adaptions to arid conditions.", location_long: 144.983053, location_lat: -37.832006, iconPath: "acacia")
        let plant1 = addPlant(scientificName: "Yucca brevifolia", plantName: "Joshua-tree", discoverYear: "1871", family: "Asparagaceae", imageUrl: "https://bs.floristic.org/image/o/25ffeb64175cf2540206a817d4ec8fcc55496a7b")
        let plant2 = addPlant(scientificName: "Agave parviflora", plantName: "smallflower century plant", discoverYear: "1858", family: "Asparagaceae", imageUrl: "https://bs.floristic.org/image/o/1f6582640227f0915a0a578d695acb863a65d7f8")
        let plant3 = addPlant(scientificName: "Cordyline fruticosa", plantName: "Broadleaf palm-lily", discoverYear: "1919", family: "Asparagaceae", imageUrl: "https://bs.floristic.org/image/o/c3d1fa9858128f4ec76a0de78d39cf14238f7df5")
        let _ = addPlantToExhibition(plant: plant1!, exhibition: exhibition1!)
        let _ = addPlantToExhibition(plant: plant2!, exhibition: exhibition1!)
        let _ = addPlantToExhibition(plant: plant3!, exhibition: exhibition1!)
        
        let exhibition2 = addExhibition(exhibitionName: "Herb Garden", exhibitionDescription: "A wide range of herbs from well known leafy annuals such as Basil and Coriander, to majestic mature trees such as the Camphor Laurels Cinnamomum camphora and Cassia Bark Tree Cinnamomum burmannii.", location_long: 144.979362, location_lat: -37.831523, iconPath: "palm-tree")
        let plant4 = addPlant(scientificName: "Thymus serpyllum", plantName: "Breckland thyme", discoverYear: "1753", family: "Lamiaceae", imageUrl: "https://bs.floristic.org/image/o/ecf77cf27a40011b8556bbd15b3d171be00ecfd5")
        let plant5 = addPlant(scientificName: "Salvia rosmarinus", plantName: "Rosemary", discoverYear: "1835", family: "Lamiaceae", imageUrl: "https://bs.floristic.org/image/o/4ac23eba5a0d5bb7c73e3ad8331614c7079dcfe0")
        let plant6 = addPlant(scientificName: "Origanum vulgare", plantName: "Oregano", discoverYear: "1753", family: "Lamiaceae", imageUrl: "https://bs.floristic.org/image/o/3ba5f26c99945c13e49d5107a7565f8c6037b7fb")
        let _ = addPlantToExhibition(plant: plant4!, exhibition: exhibition2!)
        let _ = addPlantToExhibition(plant: plant5!, exhibition: exhibition2!)
        let _ = addPlantToExhibition(plant: plant6!, exhibition: exhibition2!)
        
        let exhibition3 = addExhibition(exhibitionName: "Gardens House", exhibitionDescription: "A garden within a garden, the Garden House display garden is an enclosed area surrounding historic Gardens House.", location_long: 144.978225, location_lat: -37.829938, iconPath: "palm-tree")
        let plant7 = addPlant(scientificName: "Araucaria bidwillii", plantName: "Queensland-pine", discoverYear: "1843", family: "Araucariaceae", imageUrl: "https://bs.floristic.org/image/o/9b75fdd616d80a45c65587cb7ef54018f835b824")
        let plant8 = addPlant(scientificName: "Populus deltoides", plantName: "eastern cottonwood", discoverYear: "1785", family: "Salicaceae",imageUrl: "https://bs.floristic.org/image/o/994b792bfe110810897eb015be83fd0d85f26991")
        let plant9 = addPlant(scientificName: "Populus fremontii", plantName: "Fremont cottonwood", discoverYear: "1875", family: "Salicaceae", imageUrl: "https://bs.floristic.org/image/o/054e29643e09a06a3d75724e86f0f4a93f83d800")
        let _ = addPlantToExhibition(plant: plant7!, exhibition: exhibition3!)
        let _ = addPlantToExhibition(plant: plant8!, exhibition: exhibition3!)
        let _ = addPlantToExhibition(plant: plant9!, exhibition: exhibition3!)
        
        let exhibition4 = addExhibition(exhibitionName: "Fern Gully", exhibitionDescription: "The Fern Gully is a natural gully within the gardens providing a perfect micro climate for ferns. Visitors can follow a stream via the winding paths in the cool surrounds under the canopy of lush tree ferns.", location_long: 144.980478, location_lat: -37.831455, iconPath: "silver-fern")
        let plant10 = addPlant(scientificName: "Sphaeropteris cooperi", plantName: "Cooper's cyathea", discoverYear: "1970", family: "Cyatheaceae", imageUrl: "https://bs.floristic.org/image/o/efc106f606124839220034a1c2aa5f231f6550aa")
        let plant11 = addPlant(scientificName: "Alsophila dealbata", plantName: "", discoverYear: "1801", family: "Cyatheaceae", imageUrl: "http://d2seqvvyy3b8p2.cloudfront.net/7f7c95554d2cfd889642f185a6a6d19c.jpg")
        let plant12 = addPlant(scientificName: "Sphaeropteris glauca", plantName: "", discoverYear: "1970", family: "Cyatheaceae", imageUrl: "https://bs.floristic.org/image/o/7bc91b48f8c018fcd491784103772932e9edef46")
        let _ = addPlantToExhibition(plant: plant10!, exhibition: exhibition4!)
        let _ = addPlantToExhibition(plant: plant11!, exhibition: exhibition4!)
        let _ = addPlantToExhibition(plant: plant12!, exhibition: exhibition4!)
        
        
        let exhibition5 = addExhibition(exhibitionName: "Southern China Collection", exhibitionDescription: "China has 1/8th of the world’s plants. Many of these are important in Chinese culture and have been cultivated and celebrated in art and everyday life for centuries.", location_long: 144.980548, location_lat: -37.827510, iconPath: "willow")
        let plant13 = addPlant(scientificName: "Magnolia denudata", plantName: "lilytree", discoverYear: "1792", family: "Magnoliaceae", imageUrl: "https://bs.floristic.org/image/o/fbb5bd813e7f95d9f65d0577572bbf43ac2f917a")
        let plant14 = addPlant(scientificName: "Camellia granthamiana", plantName: "camellia-granthamiana", discoverYear: "1956", family: "Theaceae", imageUrl: "http://d2seqvvyy3b8p2.cloudfront.net/28269ad371d9960e43b31b5e3d400c5e.jpg")
        let plant15 = addPlant(scientificName: "Salvia miltiorrhiza", plantName: "Redroot sage", discoverYear: "1833", family: "Lamiaceae", imageUrl: "https://bs.floristic.org/image/o/3be1410801e021a1851b58b458c8c322434b288e")
        let _ = addPlantToExhibition(plant: plant13!, exhibition: exhibition5!)
        let _ = addPlantToExhibition(plant: plant14!, exhibition: exhibition5!)
        let _ = addPlantToExhibition(plant: plant15!, exhibition: exhibition5!)
        
    }
    
    
    
}
