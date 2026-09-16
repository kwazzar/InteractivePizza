//
//  AppContainer.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

final class AppContainer {
    static let shared = AppContainer()
    
    private init() { }
    
    private lazy var themeManager = ThemeManager()
    private lazy var router = AppRouter()
    private lazy var pizzaService = PizzaService()
    private lazy var pizzaDataSource: any PizzaDataSource = InMemoryPizzaDataSource()
    private lazy var pizzaManager = PizzaManager(dataSource: pizzaDataSource, service: pizzaService)
    private lazy var homeViewmodel = HomeViewModel(manager: pizzaManager)

    func makeThemeManager() -> ThemeManager {
        themeManager
    }

    func makeRouter() -> AppRouter {
        router
    }
    
    func makeHomeViewmodel() -> HomeViewModel {
        homeViewmodel
    }
}

// MARK: - Environment

private struct AppContainerEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppContainer = .shared
}

extension EnvironmentValues {
    var appContainer: AppContainer {
        get { self[AppContainerEnvironmentKey.self] }
        set { self[AppContainerEnvironmentKey.self] = newValue }
    }
}
