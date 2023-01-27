//
//  GlobalEnvironment.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import Foundation
import SwiftUI

class GlobalEnvironment: ObservableObject {
    @Published var clothColors = ["Red", "Orange", "Yellow", "Green", "Blue", "Pink", "Purple", "White", "Grey", "Black", "Silver", "Gold"]
    @Published var clothSizes = ["Extra Small", "Small", "Medium", "Large", "Extra Large"]
    @Published var clothTypes = ["Hat", "Top", "Bottoms", "Shoes"]
}
