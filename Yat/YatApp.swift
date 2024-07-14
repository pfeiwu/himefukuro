//
//  YatApp.swift
//  Yat
//
//  Created by Pengfei Wu on 2024/7/12.
//

import SwiftUI
import SwiftData

@main
struct YatApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Article.self,
            Record.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
