//
//  User+CoreDataProperties.swift
//  Bxpert
//
//  Created by Naveen on 28/03/25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var profilePicture: String?

}

extension User : Identifiable {

}
