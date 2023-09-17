//
//  Pets+CoreDataProperties.swift
//  Assignment
//
//  Created by Ravi Singh on 16/09/23.
//
//

import Foundation
import CoreData


extension Pets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pets> {
        return NSFetchRequest<Pets>(entityName: "Pets")
    }

    @NSManaged public var img: Data?
    @NSManaged public var id: Int64

}

extension Pets : Identifiable {

}
