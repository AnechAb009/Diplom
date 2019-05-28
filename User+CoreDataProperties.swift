//
//  User+CoreDataProperties.swift
//  
//
//  Created by Maksim Kolesnik on 27/05/2019.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var address: String?
    @NSManaged public var lastname: String?
    @NSManaged public var mail: String?
    @NSManaged public var name: String?
    @NSManaged public var group: String?
    @NSManaged public var patronymic: String?
    @NSManaged public var phone1: String?
    @NSManaged public var isStudent: Bool
    @NSManaged public var phone2: String?
    @NSManaged public var facul: String?

}
