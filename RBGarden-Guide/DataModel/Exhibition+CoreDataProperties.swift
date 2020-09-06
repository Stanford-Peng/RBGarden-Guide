//
//  Exhibition+CoreDataProperties.swift
//  RBGarden-Guide
//
//  Created by Stanford on 5/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Exhibition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exhibition> {
        return NSFetchRequest<Exhibition>(entityName: "Exhibition")
    }

    @NSManaged public var exhibitionName: String?
    @NSManaged public var exhibitionDescription: String?
    @NSManaged public var location_long: Double
    @NSManaged public var location_lat: Double
    @NSManaged public var iconPath: String?
    @NSManaged public var plants: NSSet?

}

// MARK: Generated accessors for plants
extension Exhibition {

    @objc(addPlantsObject:)
    @NSManaged public func addToPlants(_ value: Plant)

    @objc(removePlantsObject:)
    @NSManaged public func removeFromPlants(_ value: Plant)

    @objc(addPlants:)
    @NSManaged public func addToPlants(_ values: NSSet)

    @objc(removePlants:)
    @NSManaged public func removeFromPlants(_ values: NSSet)

}
