//
//  OutfitView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 28.04.2023.
//

import Foundation
import SwiftUI
import CoreData

struct AddOutfitView: View {
    @Environment(\.managedObjectContext) var moc

    @Environment(\.presentationMode) private var presentationMode
    
    @FetchRequest(
        entity: Cloth.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Cloth.id, ascending: true)],
        animation: .default)
    private var clothPieces: FetchedResults<Cloth>
    
    @FetchRequest(
        entity: Outfit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Outfit.date, ascending: false)],
        animation: .default)
    private var outfits: FetchedResults<Outfit>
    
    
    @State private var selectedTopPiece: Cloth?
    @State private var selectedBottomPiece: Cloth?
    
    @State private var showingDuplicateOutfitAlert = false
    @State private var showingWrongSelectedOutfitAlert = false
    

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Top Piece")) {
                    CategoryRow(filter: "Top", selectedCloth: $selectedTopPiece)
                        .environment(\.managedObjectContext, self.moc)
                }
                Section(header: Text("Bottom Piece")) {
                    CategoryRow(filter: "Bottoms", selectedCloth: $selectedBottomPiece)
                        .environment(\.managedObjectContext, self.moc)
                }
                
            }
            .navigationTitle("Add Outfit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveOutfit()
                    }
                    
                }
            }
            .alert(isPresented: $showingDuplicateOutfitAlert) {
                Alert(title: Text("Duplicate Outfit"),
                      message: Text("You already added an outfit of the day."),
                      dismissButton: .default(Text("OK")) {
                                    presentationMode.wrappedValue.dismiss()
                    
                    self.showingDuplicateOutfitAlert = false
                                })
            }
        }    .alert(isPresented: $showingWrongSelectedOutfitAlert) {
            Alert(title: Text("Incomplete Outfit"),
                  message: Text("Please, select two pieces of clothing for an outfit."),
                  dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                self.showingWrongSelectedOutfitAlert = false
                            })
    }
    
          
    }
    
    private func saveOutfit() {
        guard let topPiece = selectedTopPiece, let bottomPiece = selectedBottomPiece else {
            self.showingWrongSelectedOutfitAlert = true
            return
        }
        
        // Check if an outfit with the same date already exists
        let fetchRequest: NSFetchRequest<Outfit> = Outfit.fetchRequest()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let startOfDay = calendar.startOfDay(for: Date.now)
       
        fetchRequest.predicate = NSPredicate(format: "date == %@", startOfDay as NSDate)
        
        do {
            if let firstOutfit = outfits.first, let firstOutfitDate = firstOutfit.date, calendar.isDateInToday(firstOutfitDate) {
                self.showingDuplicateOutfitAlert = true
                return
            }
            
            let newOutfit = Outfit(context: moc)
            newOutfit.id = UUID()
            newOutfit.date = startOfDay
            newOutfit.topPiece = topPiece
            newOutfit.bottomPiece = bottomPiece
            
            try moc.save()
            saveOutfitToJSON(outfit: newOutfit)
            self.showingWrongSelectedOutfitAlert = false
            self.showingDuplicateOutfitAlert = false
            presentationMode.wrappedValue.dismiss()
            
        } catch {
            print("Error fetching outfits: \(error)")
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func saveOutfitToJSON(outfit: Outfit) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        var outfitsArray: [[String: Any]] = []
        
        do {
            for outfit in self.outfits {
                let data = try encoder.encode(outfit)
                if let outfitDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    outfitsArray.append(outfitDict)
                }
            }
            
            // Serializing the outfits array into JSON data
            let outfitsData = try JSONSerialization.data(withJSONObject: outfitsArray, options: [])
            
            // Gettting the app's Documents directory
            let appURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            // Save the JSON file to the app's Documents directory
            let fileURL = appURL.appendingPathComponent("outfits.json")
            
            try outfitsData.write(to: fileURL)
            
            // Print the file URL
            print("File saved to: \(fileURL)")
            
        } catch {
            print("Error encoding outfit to JSON: \(error)")
        }
    }

}

