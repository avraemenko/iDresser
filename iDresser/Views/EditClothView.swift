//
//  EditClothView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import Foundation
import SwiftUI
import CoreML

@available(iOS 14.0, *)
struct EditClothView: View {
    let cloth: Cloth
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var location = 0
    
    @State var image: Data = Data()
    @State var typeInt = 0
    @State var colorInt = 0
    @State var shelfInt = 0
    
    var body: some View {
        NavigationView {
            Form {
                ClothImageSection(image: $image)
                ClothPropertiesSection(colorInt: $colorInt, typeInt: $typeInt)
                ClothSaveSection {
                    self.cloth.imageD = self.image
                    self.cloth.color = GlobalEnvironment.clothColors[self.colorInt]
                    self.cloth.type = GlobalEnvironment.clothTypes[self.typeInt]
                    self.shelfInt = ClothUtility().updateShelfInt(type: self.cloth.type ?? "Top")
                    self.cloth.shelf = GlobalEnvironment.shelfTypes[self.shelfInt]
                    try? self.moc.save()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Edit Cloth", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            })
        }
        .onAppear {
            let (image, typeInt, colorInt, shelfInt) = ClothUtility.initializeCloth(cloth: self.cloth)
            self.image = image
            self.typeInt = typeInt
            self.colorInt = colorInt
            self.shelfInt = shelfInt
        }
    }

}
