//
//  ContentView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var env : GlobalEnvironment
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Cloth.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Cloth.id, ascending: true)
//        NSSortDescriptor(keyPath: \Cloth.imageD, ascending: true),
//        NSSortDescriptor(keyPath: \Cloth.type, ascending: true),
//        NSSortDescriptor(keyPath: \Cloth.color, ascending: true),
//        NSSortDescriptor(keyPath: \Cloth.size, ascending: false),
//        NSSortDescriptor(keyPath: \Cloth.favo, ascending: false)
        ]
    ) var clothes: FetchedResults<Cloth>
    
    @State var showAddSheet = false
    @State var showEditAction = false
    @State var showEdit = false
    @State var showAlert = false
    // @State var change = false
    
    @State var inCategoryType = ""
    
    @State var image: Data = .init(count: 0)
    @State var editCloth: Cloth?
    
    @State var clothTypeInto = ""
    @State private var search = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    SearchBar(text: self.$search)
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach (env.clothTypes.sorted(), id: \.self) { clothType in
                            VStack(alignment: .leading) {
                                if (!self.clothes.filter({clothType == $0.type!}).isEmpty) {
                                    HStack {
                                        Text(clothType)
                                            .font(.headline)
                                            .padding(.leading, 15)
                                            .padding(.top, 5)
                                        Spacer()
                                        NavigationLink(destination: InCategoryView(inClothType: clothType)
                                            .environmentObject(GlobalEnvironment())
                                            .environment(\.managedObjectContext, self.moc)) {
                                            Image(systemName: "chevron.right")
                                        }
                                        .padding(.trailing, 15)
                                    } // HStack for the Category Title
                                        .padding(.bottom, -10)
                                }
                                ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 0) {
                                    ForEach (self.clothes.filter({ self.search.isEmpty ? clothType == $0.type!: clothType == $0.type! && $0.color!.localizedCaseInsensitiveContains(self.search)}), id: \.self) { cloth in
                                        VStack {
                                            Button(action: {
                                                self.showEditAction.toggle()
                                                self.editCloth = cloth
                                            } ) {
                                                Image(uiImage: UIImage(data: cloth.imageD ?? self.image)!)
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .frame(maxWidth: 155, maxHeight: 155)
                                                    .cornerRadius(5)
                                            }
                                            .sheet(isPresented: self.$showEdit) {
                                                EditClothView(cloth: self.editCloth!)
                                                    .environmentObject(GlobalEnvironment())
                                                    .environment(\.managedObjectContext, self.moc)
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
                                }
                            }
                                // nope
                            }
                        }
                    } // Scroll view
                    .navigationBarTitle("Closet", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: {
                        self.showAddSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                    }
                        .sheet(isPresented: self.$showAddSheet) {
                            AddClothView()
                                .environment(\.managedObjectContext, self.moc)
                                .environmentObject(GlobalEnvironment())
                        }
                    )
                } // VStack for main view end
                VStack {
                    Spacer()
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            self.change.toggle()
//                        }) {
//                            Image(systemName: self.change ? "xmark": "magnifyingglass")
//                        }.padding()
//                            .foregroundColor(.white)
//                            .font(.largeTitle)
//                            .background(Color.blue.opacity(0.80))
//                            .clipShape(Circle())
//                            .shadow(color: .blue, radius: 4)
//                            .animation(.easeInOut)
//                    }.padding([.bottom, .trailing], 30)
                } // VStack for Floating button end
            } //ZStack end
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
