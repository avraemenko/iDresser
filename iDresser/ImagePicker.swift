//
//  ImagePicker.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import SwiftUI
import UIKit
import CoreML

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var show: Bool
    @Binding var image: Data
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var completionHandler: ((String) -> Void)?
    var colorCompletionHandler: ((String) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        private let classifier = VisionClassifier(mlModel: ClothingClassifier().model)
        private let colorClassifier = VisionClassifier(mlModel: ColorClassifier().model)
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let img = info[.originalImage] as? UIImage {
                let data = img.jpegData(compressionQuality: 0.45)
                self.parent.image = data!
                
                self.classifier?.classify(img) { result in
                    self.parent.completionHandler?(result)
                }
                self.colorClassifier?.classify(img) { result in
                    self.parent.colorCompletionHandler?(result)
                }
            }
            self.parent.show.toggle()
        }
    }
}
