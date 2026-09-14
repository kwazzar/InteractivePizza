//
//  InteractivePizzaApp.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import Observation

@MainActor
@Observable
final class SplashViewModel {
    private let router: AppRouter

    init(router: AppRouter) {
        self.router = router
    }

    func start() {
        Task {
            try? await Task.sleep(for: .seconds(2))
            router.navigate(to: .home)
        }
    }
}
