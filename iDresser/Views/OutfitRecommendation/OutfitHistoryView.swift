//
//  OutfitHistoryView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 28.04.2023.
//
import SwiftUI
import CoreData

struct OutfitHistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Outfit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Outfit.date, ascending: false)],
        animation: .default)
    private var outfits: FetchedResults<Outfit>

    @State private var showAddOutfitSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(outfits, id: \.self) { outfit in
                    OutfitRow(outfit: outfit)
                }
                .onDelete(perform: deleteOutfits)
            }
            .navigationTitle("Outfit History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        EditButton()
                        Button(action: {
                            showAddOutfitSheet.toggle()
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddOutfitSheet) {
                AddOutfitView()
                    .environment(\.managedObjectContext, viewContext)
            }

        }
    }

    private func deleteOutfits(offsets: IndexSet) {
        withAnimation {
            offsets.map { outfits[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct OutfitRow: View {
    var outfit: Outfit

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Date: \(formattedDate(date: outfit.date))")
                    .font(.headline)
                HStack{
                    Image(uiImage: (UIImage(data: outfit.topPiece?.imageD ?? Data()) ?? UIImage(systemName: "questionmark.app"))!)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 155, maxHeight: 155)
                        .cornerRadius(5)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                    Image(uiImage: (UIImage(data: outfit.bottomPiece?.imageD ?? Data()) ?? UIImage(systemName: "questionmark.app"))!)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 155, maxHeight: 155)
                        .cornerRadius(5)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                }
            }
            Spacer()
        }
    }

    func formattedDate(date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}


