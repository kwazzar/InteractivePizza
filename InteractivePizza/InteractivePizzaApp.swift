//
//  InteractivePizzaApp.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

@main
struct InteractivePizzaApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(container.makeThemeManager())
                .environment(container.makeRouter())
                .environment(container.makeSplashViewModel())
        }
    }
}
