//
//  Compass_TestApp.swift
//  Compass Test
//
//  Created by Martin Crespi on 05/08/2024.
//

import SwiftUI

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MainDependenciesResolver.shared.resolveViewModel())
        }
    }
}
