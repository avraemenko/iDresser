//
//  Outfit+CoreDataClass.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 28.04.2023.
//
//

import Foundation
import CoreData

@objc(Outfit)
public class Outfit: NSManagedObject, Encodable {
    
    private enum CodingKeys: String, CodingKey { case date, id, bottomPiece, topPiece }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(id, forKey: .id)
        try container.encode(bottomPiece?.type, forKey: .bottomPiece)
        try container.encode(topPiece?.type, forKey: .topPiece)
    }
}
