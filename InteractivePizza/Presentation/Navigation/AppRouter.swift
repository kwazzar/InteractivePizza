//
//  InteractivePizzaApp.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import Observation

@MainActor
@Observable
final class AppRouter {
    enum Route {
        case splash
        case home
    }

    private(set) var route: Route = .splash

    func navigate(to newRoute: Route) {
        route = newRoute
    }
}
