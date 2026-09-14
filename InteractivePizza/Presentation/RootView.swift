//
//  ContentView.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        switch router.route {
        case .splash:
            SplashView()
        case .home:
            HomeView()
        }
    }
}
