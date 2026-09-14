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
        Group {
            switch router.route {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .home:
                HomeView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: router.route)
    }
}

#Preview {
    return RootView()
        .environment(ThemeManager())
        .environment(AppRouter())
}
