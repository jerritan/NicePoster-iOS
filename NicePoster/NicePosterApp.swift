//
//  NicePosterApp.swift
//  NicePoster
//
//  Created by Haishan Tan on 2026/1/15.
//

import SwiftUI
import CoreData

@main
struct NicePosterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
