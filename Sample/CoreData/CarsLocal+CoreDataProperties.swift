//
//  CarsLocal+CoreDataProperties.swift
//  BellTechnical
//
//  Created by Ritu on 2022-09-01.
//
//

import Foundation
import CoreData


extension CarsLocal {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CarsLocal> {
        return NSFetchRequest<CarsLocal>(entityName: "CarsLocal")
    }

    @NSManaged public var consList: NSObject?
    @NSManaged public var customerPrice: Double
    @NSManaged public var make: String?
    @NSManaged public var marketPrice: Double
    @NSManaged public var model: String?
    @NSManaged public var prosList: NSObject?
    @NSManaged public var rating: Int16

}

extension CarsLocal : Identifiable {

}
