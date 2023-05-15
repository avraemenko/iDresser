//
//  ContentView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            WardrobeView()
                .environment(\.managedObjectContext, self.moc)
                .tabItem {
                    VStack {
                        Image(systemName: "rectangle.stack")
                        Text("Wardrobe")
                    }
                }
                .tag(0)

            OutfitHistoryView()
                .environment(\.managedObjectContext, self.moc)
                .tabItem {
                    VStack {
                        Image(systemName: "clock")
                        Text("Outfits")
                    }
                }
                .tag(1)
        }.onAppear{
            DispatchQueue.main.async {
                LocationManager.shared.requestLocation()
              
                } 
        }
    }
}
