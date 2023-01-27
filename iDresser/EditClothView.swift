//
//  EditClothView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import Foundation
import SwiftUI

struct EditClothView: View {
    let cloth: Cloth
    @EnvironmentObject var env : GlobalEnvironment
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
        
    @State var show = false
    @State var showAction = false
    
//    @State var id: UUID
    @State var image: Data

    @State var typeInt = 0
    @State var colorInt = 0
    @State var sizeInt = 0
        
    init(cloth: Cloth) {
        self.cloth = cloth
//        self._id = State(initialValue: cloth.id ?? UUID())
        self._image = State(initialValue: cloth.imageD ?? .init(count: 0))
    }
    
    @State var sourceType : UIImagePickerController.SourceType = .camera
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("IMAGE")) {
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
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .onTapGesture {
                        self.showAction.toggle()
                    }
                }
                Section(header: Text("CLOTH TYPE")) {
                    Picker("Type", selection: $typeInt) {
                        ForEach(0 ..< env.clothTypes.count) {
                            Text(self.env.clothTypes[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("PROPERTIES")) {
                    Picker("Color", selection: $colorInt) {
                        ForEach(0 ..< env.clothColors.count) {
                            Text(self.env.clothColors[$0])
                        }
                    }
                    Picker("Size", selection: $sizeInt) {
                        ForEach(0 ..< env.clothSizes.count) {
                            Text(self.env.clothSizes[$0])
                        }
                    }
                }
                Section(header: Text("SAVE")) {
                    Button(action: {
                        self.cloth.imageD = self.image
                        self.cloth.color = self.env.clothColors[self.colorInt]
                        self.cloth.type = self.env.clothTypes[self.typeInt]
                        self.cloth.size = self.env.clothSizes[self.sizeInt]
                        
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                        self.colorInt = 0
                        self.typeInt = 0
                        self.sizeInt = 0
                    }) {
                        Text("Save")
                    }
                }
            }
            .navigationBarTitle("Edit Cloth", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            })
        }
        //Action Bar Start
        .actionSheet(isPresented: self.$showAction) {
            ActionSheet(title: Text("Select Image"), buttons:[
                .default(Text("Camera")) {
                    self.show.toggle()
                    self.sourceType = .camera
                },
                .default(Text("Saved Images")) {
                    self.show.toggle()
                    self.sourceType = .photoLibrary
                }
            ])
        }
            // Action Bar End
        .sheet(isPresented: self.$show, content: {
            ImagePicker(show: self.$show, image: self.$image, sourceType: self.sourceType)
        })
    }
}
