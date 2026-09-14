//
//  InteractivePizzaApp.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct SplashView: View {
    @Environment(ThemeManager.self) private var theme
    @Environment(SplashViewModel.self) private var viewModel

    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()

            Image("SplashPizza")
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 270)
        }
        .onAppear {
            viewModel.start()
        }
    }
}
