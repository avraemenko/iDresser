//
//  CategoryRow.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import Foundation
import SwiftUI

struct CategoryRow: View {
    var fetchRequest: FetchRequest<Cloth>
    var filteredCloth: FetchedResults<Cloth> {
        fetchRequest.wrappedValue
    }
    
    var shelf: String
    @Binding var selectedCloth: Cloth?
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(filteredCloth, id: \.self) { cloth in
                        CategoryItem(cloth: cloth, isSelected: cloth == selectedCloth)
                            .onTapGesture {
                                selectedCloth = cloth
                            }
                    }
                }
            }
            .frame(height: 185)
        }
    }
    
    init(filter: String, selectedCloth: Binding<Cloth?>) {
        fetchRequest = FetchRequest<Cloth>(entity: Cloth.entity(), sortDescriptors: [], predicate: NSPredicate(format: "shelf == %@", filter))
        shelf = filter
        _selectedCloth = selectedCloth
    }
}


struct CategoryItem: View {
    var cloth: Cloth
    var isSelected: Bool
    var body: some View {
        
        VStack(alignment: .leading) {
            Image(uiImage: UIImage(data: cloth.imageD!)!)
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 155, maxHeight: 155)
                .cornerRadius(5)
                .aspectRatio(contentMode: .fit)
                .clipped()
            Text(cloth.color! + " " + cloth.type!)
                .font(.caption)
        }
        .padding(.leading, 15)
        .opacity(isSelected ? 0.6 : 1)
        .overlay(isSelected ? Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 22)) : nil, alignment: .bottomTrailing)
    }
}

