//
//  iDresserApp.swift
//  iDresser
//
//  Created by Kateryna Avramenko on 05.04.2023.
//

import SwiftUI

@main
struct iDresserApp: App {
    @Environment(\.scenePhase) private var scenePhase
    private var globalEnvironment = GlobalEnvironment()

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                persistenceController.saveContext()
            default:
                break
            }
        }
    }
}
