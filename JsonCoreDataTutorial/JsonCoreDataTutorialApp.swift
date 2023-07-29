//
//  JsonCoreDataTutorialApp.swift
//  JsonCoreDataTutorial
//
//  Created by Eymen on 29.07.2023.
//

import SwiftUI

@main
struct JsonCoreDataTutorialApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
