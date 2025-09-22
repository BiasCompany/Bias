//
//  lumiApp.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/16/25.
//

import SwiftData
import SwiftUI

@main
struct lumiApp: App {

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(DIContainer.shared.localDataSource.container)
        }
    }
}
