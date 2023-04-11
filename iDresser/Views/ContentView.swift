//
//  ContentView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import Foundation
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Cloth.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Cloth.id, ascending: true)
        ]
    ) var clothes: FetchedResults<Cloth>
    
    
    @State var showAddSheet = false
    @State var showEditAction = false
    @State var showEdit = false
    @State var showAlert = false
    
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
                        ForEach(GlobalEnvironment.shelfTypes, id: \.self) { shelf in
                            VStack(alignment: .leading) {
                                if (!self.clothes.filter({shelf == $0.shelf}).isEmpty) {
                                    HStack {
                                        Text(shelf)
                                            .font(.headline)
                                            .padding(.leading, 15)
                                            .padding(.top, 5)
                                        Spacer()
                                        NavigationLink(destination: InCategoryView(inClothType: shelf)
                                            .environment(\.managedObjectContext, self.moc)) {
                                            Image(systemName: "chevron.right")
                                        }
                                        .padding(.trailing, 15)
                                    } // HStack for the Category Title
                                        .padding(.bottom, -10)
                                }
                                ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 0) {
                                    ForEach (self.clothes.filter({ self.search.isEmpty ? shelf == $0.shelf: shelf == $0.shelf && $0.color!.localizedCaseInsensitiveContains(self.search)}), id: \.self) { cloth in
                                       
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
                                }
                            }
                                // nope
                            }
                        }
                    }
                   
                    .navigationBarTitle("iDresser", displayMode: .inline)
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
        
                // VStack for main view end
                Color.clear.onTapGesture {
                                  UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                              }
            } .onAppear {
                print (clothes)
            }//ZStack end
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

    func deleteAllClothes() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Cloth")

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try moc.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Error occurred while deleting objects: \(error.localizedDescription)")
        }
    }
}
