//
//  AddClothView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import SwiftUI

struct AddClothView: View {
    @EnvironmentObject var env : GlobalEnvironment
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State var image: Data = .init(count: 0)
    
    @State var show = false
    @State var showAction = false
    @State var showAlert = false
    
    @State var id = 0
    @State var typeInt = 0
    @State var colorInt = 0
    @State var sizeInt = 0
    @State private var classificationLabel: String = ""
    @State var sourceType : UIImagePickerController.SourceType = .camera
    @State private var uiImage: UIImage?
    
    private let classifier = VisionClassifier(mlModel: ClothingClassifier_1().model)
    
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
                Section(header: Text("Classification")) {
                    
                    Text(classificationLabel)
                    
                  //  Spacer()
                    
                    Button("Classify") {
                        self.uiImage = UIImage(data: self.image)!
                        if let img = self.uiImage {
                            // perform image classification
                            self.classifier?.classify(img) { result in
                                self.classificationLabel = result
                            }
                        }
                    }.padding()
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                Section(header: Text("SAVE")) {
                    Button(action: {
                        if (self.image == .init(count: 0)) {
                            self.showAlert.toggle()//error message
                        } else {
                        let send = Cloth(context: self.moc)
                            send.id = UUID()
                            send.color = self.env.clothColors[self.colorInt]
                            send.type = self.env.clothTypes[self.typeInt]
                            send.size = self.env.clothSizes[self.sizeInt]
                            send.imageD = self.image
                        }
                        
                        //try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                        self.colorInt = 0
                        self.typeInt = 0
                        self.sizeInt = 0
                    }) {
                        Text("Save")
                    }
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
            // Action Bar End
        .sheet(isPresented: self.$show, content: {
            ImagePicker(show: self.$show, image: self.$image, sourceType: self.sourceType)
        })
    }
}

struct AddClothView_Previews: PreviewProvider {
    static var previews: some View {
        AddClothView().environmentObject(GlobalEnvironment())
    }
}
