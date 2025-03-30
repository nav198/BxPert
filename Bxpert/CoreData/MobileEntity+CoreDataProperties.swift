//
//  MobileEntity+CoreDataProperties.swift
//  Bxpert
//
//  Created by Naveen on 28/03/25.
//
//

import Foundation
import CoreData


extension MobileEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MobileEntity> {
        return NSFetchRequest<MobileEntity>(entityName: "MobileEntity")
    }

    @NSManaged public var capacity: String?
    @NSManaged public var color: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double

}

extension MobileEntity : Identifiable {

}
