//
//  RootView.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var router

    @State private var viewModel: HomeViewModel
    @State private var splashViewModel = SplashViewModel()

    init(
        viewModel: HomeViewModel
    ) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            switch router.route {
            case .splash:
                SplashView(splashViewModel: splashViewModel)
            case .home:
                HomeView(viewModel: viewModel)
            }
        }
        .animation(
            .easeInOut(duration: 0.35),
            value: router.route
        )
        .task {
            async let loadTask = viewModel.load()
            async let splashTask = splashViewModel.animationPizza()

            await loadTask
            await splashTask

            withAnimation {
                router.navigate(to: .home)
            }
        }
    }
}

#Preview {
    RootView(viewModel: HomeViewModel())
        .environment(ThemeManager())
        .environment(AppRouter())
}
