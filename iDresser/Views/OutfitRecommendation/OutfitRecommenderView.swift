//
//  OutfitRecommenderView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.04.2023.
//

import SwiftUI
import CoreData

struct OutfitRecommenderView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Cloth.entity(), sortDescriptors: []) var clothes: FetchedResults<Cloth>
    
    @State private var topImage: Data? = nil
    @State private var bottomImage: Data? = nil
    @State private var randomEmoji: String = ""
    @State private var temperature: Int = 25
    
      var body: some View {
          NavigationView {
              VStack {
                  Text("It's \(temperature)\u{00B0} today")
                      .font(.title)
                      .padding(.top)
                  
                  Text(randomEmoji)
                      .font(.system(size: 50))
                  if let topImageData = topImage, let topUIImage = UIImage(data: topImageData) {
                      Image(uiImage: topUIImage)
                          .resizable()
                          .scaledToFit()
                          .frame(maxWidth: 300, maxHeight: 300)
                  } else {
                      VStack {
                          Text("No top available:(")
                          
                          NavigationLink(destination: AddClothView()) {
                              Text("Add More Top Clothes")
                                  .foregroundColor(.white)
                                  .padding()
                                  .background(Color.gray)
                          }
                      }.frame(maxWidth: 300, maxHeight: 300, alignment: .center)
                  }
                  
                  Divider()
                  
                  if let bottomImageData = bottomImage, let bottomUIImage = UIImage(data: bottomImageData) {
                      Image(uiImage: bottomUIImage)
                          .resizable()
                          .scaledToFit()
                          .frame(maxWidth: 400, maxHeight: 400)
                  } else {
                      VStack {
                          
                          Text("No bottom available:(")
                              .font(.system(size: 10))
                              .foregroundColor(.gray)
                          
                          NavigationLink(destination: AddClothView()) {
                              Text("Add More Bottom Clothes")
                                  .foregroundColor(.white)
                                  .padding()
                                  .background(Color.gray)
                                  .cornerRadius(15)
                          }
                      }.frame(maxWidth: 400, maxHeight: 400, alignment: .center)
                  }
              }
              .onAppear {
                  fetchOutfit()
              }
          }
      }
  
    
    func fetchOutfit() {
        let recommender = ClothingRecommender(temperature: 25)
        recommender.getTopCloth()
        recommender.getBottomCloth()
        let tops = clothes.filter { $0.shelf == "Top" }
        let bottoms = clothes.filter { $0.shelf == "bottom" }
        
        if let randomTop = tops.randomElement() {
            topImage = randomTop.imageD ?? Data()
        }
        
        if let randomBottom = bottoms.randomElement() {
            bottomImage = randomBottom.imageD ?? Data()
        }
        
        randomEmoji = getRandomEmoji()
    }
    
    func getRandomEmoji() -> String {
        let emojiStart = 0x1F600
        let ascii = emojiStart + Int(arc4random_uniform(UInt32(64)))
        let emoji = UnicodeScalar(ascii) ?? UnicodeScalar(emojiStart)!
        return String(emoji)
    }
}

