//
//  Cloth+CoreDataProperties.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//
//

import Foundation
import CoreData


extension Cloth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cloth> {
        return NSFetchRequest<Cloth>(entityName: "Cloth")
    }

    @NSManaged public var color: String?
    @NSManaged public var favo: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var imageD: Data?
    @NSManaged public var type: String?
    @NSManaged public var shelf: String?

}

extension Cloth : Identifiable {

}
