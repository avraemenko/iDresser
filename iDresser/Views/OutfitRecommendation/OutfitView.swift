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
    
    @State private var selectedTopPiece: Cloth?
    @State private var selectedBottomPiece: Cloth?
    
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
                        //                        saveOutfit()
                        guard let topCloth = self.selectedTopPiece, let bottomCloth = self.selectedBottomPiece else {
                            return
                        }
                        let newOutfit = Outfit(context: self.moc)
                        newOutfit.id = UUID()
                        newOutfit.date = Date()
                        newOutfit.topPiece = topCloth
                        newOutfit.bottomPiece = bottomCloth
                        do {
                            try self.moc.save()
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            print("Error saving new outfit: \(error)")
                        }
                    }
                    
                }
            }
        }
    }
    
    private func saveOutfit() {
        guard let topPiece = selectedTopPiece, let bottomPiece = selectedBottomPiece else {
            // Handle the case when either top or bottom piece is not selected
            return
        }
        // Check if an outfit with the same date already exists
        let fetchRequest: NSFetchRequest<Outfit> = Outfit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", Calendar.current.startOfDay(for: Date()) as NSDate)
        let outfits = try? moc.fetch(fetchRequest)
        if let _ = outfits?.first {
            // Handle the case when an outfit with the same date already exists
            return
        }
        let newOutfit = Outfit(context: moc)
        newOutfit.id = UUID()
        newOutfit.date = Calendar.current.startOfDay(for: Date())
        newOutfit.topPiece = topPiece
        newOutfit.bottomPiece = bottomPiece
        do {
            try moc.save()
            saveOutfitToJSON(outfit: newOutfit)
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    private func saveOutfitToJSON(outfit: Outfit) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(outfit)
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsURL.appendingPathComponent("outfits.json")
            try data.write(to: fileURL)
        } catch {
            print("Error encoding outfit to JSON: \(error)")
        }
    }
}

