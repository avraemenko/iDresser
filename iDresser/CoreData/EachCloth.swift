//
//  EachCloth.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import Foundation

class EachCloth {
    private(set) var clothID: UUID
    private(set) var clothImageD: Data
    private(set) var clothType: String
    private(set) var clothColor: String
    private(set) var shelfType: String
    
    init(clothImageD: Data, clothType: String, clothColor: String, shelfType : String) {
        self.clothID = UUID()
        self.clothImageD = clothImageD
        self.clothType = clothType
        self.clothColor = clothColor
        self.shelfType = shelfType
    }
    
    init(clothID: UUID, clothImageD: Data, clothType: String, clothColor: String, shelfType : String) {
        self.clothID = clothID
        self.clothImageD = clothImageD
        self.clothType = clothType
        self.clothColor = clothColor
        self.shelfType = shelfType
    }
}
