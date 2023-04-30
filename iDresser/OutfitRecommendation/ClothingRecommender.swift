//
//  ClothingRecommender.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 07.04.2023.
//

import Foundation

class ClothingRecommender{
    
    var recommendedOutfit : String? = ""
    
    init(temperature: Double){
        let recommender = OutfitRecommender()
        guard let modelInput = try? OutfitRecommenderInput(temperature: temperature) else {
            fatalError("Failed to create input feature provider.")
        }
        // Make predictions
        do {
            let prediction = try recommender.prediction(input: modelInput)
            self.recommendedOutfit = prediction.featureValue(for: "outfit")?.stringValue
        } catch {
            print("Error making predictions: \(error.localizedDescription)")
        }
    }
    
    func getTopCloth() -> String {
        if let recommendedOutfit = recommendedOutfit {
            let outfitComponents = recommendedOutfit.split(separator: "_")
            let recommendedTop = outfitComponents[1]
            print("Top: \(recommendedTop)")
            return String(recommendedTop)
        } else {
            print("Error: Could not extract recommended outfit.")
        }
        
        return "No top recommended."
    }
    
    func getBottomCloth() -> String {
        if let recommendedOutfit = recommendedOutfit {
            let outfitComponents = recommendedOutfit.split(separator: "_")
            let recommendedBottom = outfitComponents[0]
            print("Bottom: \(recommendedBottom)")
            return String(recommendedBottom)
        } else {
            print("Error: Could not extract recommended outfit.")
        }
        
        return "No top recommended."
    }
    
    
    
}
