//
//  biasApp.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/16/25.
//

import SwiftData
import SwiftUI

@main
struct biasApp: App {

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(DIContainer.shared.localDataSource.container)
        }
    }
}
