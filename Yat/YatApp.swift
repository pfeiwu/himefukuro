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
 
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    private var permissionsService = PermissionsService()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Article.self,
            Record.self,
            Book.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print(URL.applicationSupportDirectory.path(percentEncoded: false))
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
       
        WindowGroup() {
            MainView()
                .onAppear(perform: self.permissionsService.pollAccessibilityPrivileges)
        }
        .onChange(of: StateManager.shared.titleString) { newValue in
            print("titleString changed to \(newValue)")
            if let window = NSApplication.shared.windows.first {
                    window.title = newValue
                }
        }
        
        .modelContainer(sharedModelContainer)
        
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
