//
//  ModelTrainer.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 01.05.2023.
//

import SwiftUI
import CreateML
import Foundation
import CoreML
import CreateMLComponents

//func trainOutfitModel(fromJSONFile jsonFile: URL) -> MLModel? {
//    do {
//        // Load the JSON file into a DataFrame
//        let data = try MLDataTable(contentsOf: jsonFile)
//
//        // Split the data into training (80%) and validation (20%) sets
//        let (trainingData, validationData) = data.randomSplit(by: 0.8)
//
//        // Define the target column and feature columns
//        let targetColumn = "outfit"
//        let featureColumns = ["temperature"]
//
//        // Train the model using the TabularClassifier
//        let model = try MLTabularClassifier(trainingData: trainingData,
//                                            targetColumn: targetColumn,
//                                            featureColumns: featureColumns)
//
//        // Evaluate the model on the validation data
//        let evaluation = model.evaluation(on: validationData)
//        print("Evaluation: \(evaluation)")
//
//        return model
//    } catch {
//        print("Error training model: \(error)")
//        return nil
//    }
//}

