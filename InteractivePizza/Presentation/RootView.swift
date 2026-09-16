//
//  RootView.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.appContainer) private var appContainer
    @State private var splashViewModel = SplashViewModel()
    
    var body: some View {
        Group {
            switch router.route {
            case .splash:
                SplashView(splashViewModel: splashViewModel) {
                    router.navigate(to: .home)
                }
            case .home:
                HomeView(viewModel: appContainer.makeHomeViewmodel())
            }
        }
        .task {
            await appContainer.makeHomeViewmodel().load()
        }
    }
}

#Preview {
    RootView()
        .environment(ThemeManager())
        .environment(AppRouter())
}
