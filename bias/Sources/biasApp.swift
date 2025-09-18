//
//  biasApp.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/16/25.
//

import SwiftUI
import SwiftData

@main
struct biasApp: App {
    let container: ModelContainer = {
        // Persisted on disk
        try! LocalDataSource.makeDefaultContainer()
    }()


    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(container) // inject to SwiftUI environment
                .environment(LocalDataSource(container: container))
        }
    }
}
