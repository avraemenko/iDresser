//
//  InCategoryView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import Foundation
import SwiftUI

struct InCategoryView: View {
        @Environment(\.managedObjectContext) var moc
        @FetchRequest(entity: Cloth.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Cloth.id, ascending: true)
            ]
        ) var clothes: FetchedResults<Cloth>
        
        @State var showAddSheet = false
        @State var showEditAction = false
        @State var showEdit = false
        @State var showAlert = false
        
        @State var inClothType: String
        @State var image: Data = .init(count: 0)
        @State var editCloth: Cloth?
        
        
        var body: some View {
            NavigationView {
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach (GlobalEnvironment.clothColors.sorted(), id: \.self) { clothColor in
                            VStack(alignment: .leading) {
                                if (!self.clothes.filter({clothColor == $0.color! && self.inClothType == $0.shelf}).isEmpty) {
                                    Text(clothColor)
                                        .font(.headline)
                                        .padding(.leading, 15)
                                        .padding(.top, 5)
                                }
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .top, spacing: 0) {
                                        ForEach (self.clothes.filter({ clothColor == $0.color! && self.inClothType == $0.shelf }), id: \.self) { cloth in
                                            VStack {
                                                Button(action: {
                                                    self.showEditAction.toggle()
                                                    self.editCloth = cloth
                                                } ) {
                                                    Image(uiImage: UIImage(data: cloth.imageD ?? self.image)!)
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(maxWidth: 155, maxHeight: 155)
                                                        .cornerRadius(5)
                                                        .aspectRatio(contentMode: .fit)
                                                        .clipped()
                                                }
                                                .sheet(isPresented: self.$showEdit) {
                                                    if #available(iOS 14.0, *) {
                                                        EditClothView(cloth: self.editCloth!)
                                                            .environment(\.managedObjectContext, self.moc)
                                                    } else {
                                                        // Fallback on earlier versions
                                                    }
                                                }
                                                HStack {
                                                    Text("\(cloth.color ?? "") \(cloth.type ?? "")")
                                                    Spacer()
                                                    Button(action: {
                                                        cloth.favo.toggle()
                                                        try? self.moc.save()
                                                    }) {
                                                    Image(systemName: cloth.favo ? "heart.fill": "heart")
                                                    }
                                                }
                                            }
                                        }.padding()
                                        
                                    } // end of ForEach
                                } // end of ScrollView
                             
                            }
                        }
                    }
                  
                    .navigationBarItems(trailing: Button(action: {
                        self.showAddSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                    }
                        .sheet(isPresented: self.$showAddSheet) {
                            AddClothView()
                                .environment(\.managedObjectContext, self.moc)
                        }
                    )
                }
            }
            .actionSheet(isPresented: self.$showEditAction) {
                ActionSheet(title: Text("Select Options"), buttons: [
                    .default(Text("Edit")) {
                        self.showEdit.toggle()
                    },
                    .destructive(Text("Delete")) {
                        self.showAlert.toggle()
                    },
                    .cancel({ self.editCloth = Cloth.init() })
                ])
            }
            .alert(isPresented: self.$showAlert) {
                Alert(
                    title: Text("Are you sure to delete the item?"),
                    primaryButton: .destructive(Text("Yes"), action: { self.deleteCloth() }),
                    secondaryButton: .cancel(Text("No"))
                )
            }
        }
        
        func deleteCloth() {
            let dCloth = self.editCloth!
            self.moc.delete(dCloth)
            try? self.moc.save()
        }
}
