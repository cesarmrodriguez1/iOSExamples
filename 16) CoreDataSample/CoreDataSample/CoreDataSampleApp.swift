//
//  CoreDataSampleApp.swift
//  CoreDataSample
//
//  Created by gdaalumno on 06/10/21.
//

import SwiftUI

@main
struct CoreDataSampleApp: App {
    let persistenceContainer = PersistanceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
