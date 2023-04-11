//
//  ClothSaveSection.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 06.04.2023.
//

import SwiftUI

struct ClothSaveSection: View {
    var action: () -> Void

    var body: some View {
        Section(header: Text("SAVE")) {
            Button(action: {
                action()
            }) {
                Text("Save")
            }
        }
    }
}

