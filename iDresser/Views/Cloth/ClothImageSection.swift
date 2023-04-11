//
//  ClothImageSection.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 06.04.2023.
//

import SwiftUI

struct ClothImageSection: View {
    @Binding var image: Data

    var body: some View {
        Section(header: Text("")) {
            ZStack {
                if (self.image.count != 0) {
                    Image(uiImage: UIImage(data: self.image)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .cornerRadius(6)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.secondary)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(6)
                }
            }
        }
    }
}
