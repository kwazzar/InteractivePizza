//
//  InteractivePizzaApp.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import Foundation

@MainActor
final class AppContainer {
    private lazy var themeManager = ThemeManager()
    private lazy var router = AppRouter()

    func makeThemeManager() -> ThemeManager {
        themeManager
    }

    func makeRouter() -> AppRouter {
        router
    }
}
