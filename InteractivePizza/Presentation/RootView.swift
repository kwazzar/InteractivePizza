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
                SplashView(splashViewModel: splashViewModel)
                    .onAppear {
                        handleSplashScreenAppearance()
                    }
            case .home:
                HomeView(viewModel: appContainer.makeHomeViewmodel())
            }
        }
        .task {
            async let loadTask = appContainer.makeHomeViewmodel().load()
            await loadTask
        }
    }
    
    private func handleSplashScreenAppearance() {
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            
            router.navigate(to: .home)
            
        }
    }
}

#Preview {
    RootView()
        .environment(ThemeManager())
        .environment(AppRouter())
}
