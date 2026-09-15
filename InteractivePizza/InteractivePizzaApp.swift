//
//  InteractivePizzaApp.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

@main
struct InteractivePizzaApp: App {
    @State private var container = AppContainer.shared

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: container.makeHomeViewmodel())
                .environment(\.appContainer, container)
                .environment(container.makeThemeManager())
                .environment(container.makeRouter())
                
        }
    }
}
