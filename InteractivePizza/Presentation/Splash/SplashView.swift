//
//  SplashView.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct SplashView: View {
    @Environment(AppRouter.self) private var router

    @State private var frame = 0
    @State private var shrinking = false

    private let images = (1...8).map { "pizza\($0)" }

    var body: some View {
        VStack {
            Spacer()
            Image(images[frame])
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 270)
                .shadow(color: .black.opacity(0.5), radius: 4, y: 2)
                .scaleEffect(shrinking ? 0.05 : 1)
                .opacity(shrinking ? 0 : 1)
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .task {
            await animationPizza()
            router.navigate(to: .home)
        }
    }
}

private extension SplashView {
    func animationPizza() async {
        for index in 1...images.count {
            try? await Task.sleep(for: .milliseconds(70))
            frame = min(index, images.count - 1)
        }
        try? await Task.sleep(for: .milliseconds(80))
        withAnimation(.easeIn(duration: 0.2)) {
            shrinking = true
        }
        try? await Task.sleep(for: .milliseconds(200))
    }
}
