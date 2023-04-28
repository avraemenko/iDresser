//
//  Outfit+CoreDataProperties.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 28.04.2023.
//
//

import Foundation
import CoreData


extension Outfit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Outfit> {
        return NSFetchRequest<Outfit>(entityName: "Outfit")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var topPiece: Cloth?
    @NSManaged public var bottomPiece: Cloth?

}

extension Outfit : Identifiable {
    

}
