//
//  MOTransformation+CoreDataClass.swift
//  iOS-Avanzado-Dbz
//
//  Created by Kevin Heredia on 23/10/24.
//
//

import Foundation
import CoreData

@objc(MOTransformation)
public class MOTransformation: NSManagedObject {

}

extension MOTransformation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOTransformation> {
        return NSFetchRequest<MOTransformation>(entityName: "CDTransformation")
    }

    @NSManaged public var id: String?
    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var hero: MOHero?

}

extension MOTransformation : Identifiable {

}
