//
//  ClothPropertiesSection.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 06.04.2023.
//

import SwiftUI

struct ClothPropertiesSection: View {
    @Binding var colorInt: Int
    @Binding var typeInt: Int

    var body: some View {
        Section(header: Text("PROPERTIES")) {
            Picker("Color", selection: $colorInt) {
                ForEach(GlobalEnvironment.clothColors.indices, id: \.self) {
                    Text(GlobalEnvironment.clothColors[$0])
                }
            }
            Picker("Type", selection: $typeInt) {
                ForEach(GlobalEnvironment.clothTypes.indices, id: \.self) {
                    Text(GlobalEnvironment.clothTypes[$0])
                }
            }
        }
    }
}

