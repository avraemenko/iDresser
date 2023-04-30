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
    @State private var recommendedTopClothType = ""
    @State private var recommendedBottomClothType = ""
    
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
                          Text("The recommended top for today is \(recommendedTopClothType).")
                          
                          NavigationLink(destination: AddClothView()) {
                              Text("Add More \(recommendedTopClothType)s")
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
                          NavigationLink(destination: AddClothView()) {
                              Text("Add More \(recommendedBottomClothType)")
                                  .foregroundColor(.white)
                                  .padding()
                                  .background(Color.gray)
                                  .cornerRadius(15)
                          }
                          Text("The recommended bottom for today is \(recommendedBottomClothType).")
                              .font(.system(size: 10))
                              .foregroundColor(.gray)
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
        let tops = clothes.filter { $0.shelf == "Top" }
        let bottoms = clothes.filter { $0.shelf == "Bottoms" }
    
        recommendedTopClothType = recommender.getTopCloth()
        recommendedBottomClothType = recommender.getBottomCloth()
        
        let desiredTops = tops.filter { top in
            top.type?.lowercased() == recommendedTopClothType.lowercased()
        }

        if let randomDesiredTop = desiredTops.randomElement() {
            if let imageD = randomDesiredTop.imageD {
                print("Random desired top: \(randomDesiredTop)")
                topImage = randomDesiredTop.imageD ?? Data()
            } else {
                print("Random desired top does not have an imageD property.")
            }
        } else {
          
        }
        
        let desiredBottoms = bottoms.filter { bottom in
            bottom.type?.lowercased() == recommendedBottomClothType.lowercased()
        }
        print(recommendedTopClothType)
        print(desiredTops, desiredBottoms)
        
        if let randomDesiredBottom = desiredBottoms.randomElement() {
            if let imageD = randomDesiredBottom.imageD {
                bottomImage = randomDesiredBottom.imageD ?? Data()
                print("Random desired bottom: \(randomDesiredBottom)")
            } else {
                print("Random desired bottom does not have an imageD property.")
            }
        } else {
           // print("The recommended top for today is \(recommendedTopClothType).")
        }
        
        randomEmoji = getRandomEmoji()
    }
    
    func getRandomEmoji() -> String {
        let happyEmojis = ["😀", "😃", "😄", "😁", "😆", "☺️", "😊", "😇"]
        let randomIndex = Int(arc4random_uniform(UInt32(happyEmojis.count)))
        return happyEmojis[randomIndex]
    }

}

