//
//  ClothTypeView.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 27.01.23.
//

import Foundation
import SwiftUI

struct ClothTypeView: View {
    @EnvironmentObject var env : GlobalEnvironment

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ForEach (env.clothTypes.sorted(), id: \.self) { clothType in

                        VStack{
                            Text("\(clothType)")

                        }
                    }
                }
            }
        }
    }
}

struct ClothTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ClothTypeView()                                .environmentObject(GlobalEnvironment())

    }
}
