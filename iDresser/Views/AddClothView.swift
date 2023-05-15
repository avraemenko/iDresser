//
//  AddClothView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import SwiftUI
import CoreML

struct AddClothView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State var image: Data = .init(count: 0)

    @State var show = false
    @State var showAction = false
    @State var showAlert = false

    @State var id = 0
    @State var shelfInt = 0
    @State var typeInt = 0
    @State var colorInt = 0
    @State var sourceType : UIImagePickerController.SourceType = .camera
    @State private var uiImage: UIImage?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("IMAGE")) {
                    ZStack {
                        ClothImageSection(image: $image)
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .onTapGesture {
                        self.showAction.toggle()
                    }
                }
                ClothPropertiesSection(colorInt: $colorInt, typeInt: $typeInt)
                Button(action: {
                    if (self.image == .init(count: 0)) {
                        self.showAlert.toggle()
                    } else {
                        let send = Cloth(context: self.moc)
                        send.id = UUID()
                        send.color = GlobalEnvironment.clothColors[self.colorInt]
                        send.type = GlobalEnvironment.clothTypes[self.typeInt]
                        send.shelf = GlobalEnvironment.shelfTypes[ClothUtility().updateShelfInt(type: send.type ?? "Hat")]
                        send.imageD = self.image
                        do {
                            try self.moc.save()
                        } catch {
                            print("Error saving the new cloth: \(error)")
                        }
                        self.presentationMode.wrappedValue.dismiss()
                        self.colorInt = 0
                        self.typeInt = 0
                    }
                }) {
                    Text("Save")
                }
            }
            .navigationBarTitle("Add New Cloth", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            })
            .alert(isPresented: self.$showAlert) {
                Alert(title: Text("Please select an image"), dismissButton: .cancel()
                )
            }
        }
        //Action Bar Start
        .actionSheet(isPresented: self.$showAction) {
            ActionSheet(title: Text("Select Image"), message: Text("Please Select"), buttons:[
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
        .sheet(isPresented: self.$show, content: {
            ImagePicker(show: self.$show, image: self.$image, sourceType: self.sourceType,
                completionHandler: { classificationLabel in
                self.typeInt = GlobalEnvironment.clothTypes.firstIndex(of: classificationLabel) ?? 0
                self.shelfInt = ClothUtility.getShelfInt(from: classificationLabel)
                },
                colorCompletionHandler: { colorLabel in
                if let index = GlobalEnvironment.clothColors.firstIndex(where: { $0.lowercased() == colorLabel }) {
                    self.colorInt = index
                } else {
                    print("Color not found")
                }
                }
            )
        })

    }

}

