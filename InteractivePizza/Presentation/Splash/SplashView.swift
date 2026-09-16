//
//  SplashView.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct SplashView: View {
    @State var splashViewModel: SplashViewModel
    var onFinish: () -> Void = {}

    var body: some View {
        VStack {
            Spacer()
            Image(splashViewModel.images[splashViewModel.frame])
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 270)
                .shadow(color: .black.opacity(0.5), radius: 4, y: 2)
                .scaleEffect(splashViewModel.shrinking ? 0.05 : 1)
                .opacity(splashViewModel.shrinking ? 0 : 1)
            Spacer()
        }
        .task {
            await splashViewModel.animationPizza()
            onFinish()
        }
        .background(Color.white.ignoresSafeArea())
    }
}

@Observable
final class SplashViewModel {
    var frame: Int = 0
    var shrinking: Bool = false
    
    let images = (1...8).map { "pizza\($0)" }
    
    func animationPizza() async {
        let endTime = CFAbsoluteTimeGetCurrent() + 0.87
        while CFAbsoluteTimeGetCurrent() < endTime {
            for index in 1...images.count {
                try? await Task.sleep(for: .milliseconds(120))
                frame = index - 1
            }
        }
        try? await Task.sleep(for: .milliseconds(80))
        withAnimation(.easeIn(duration: 0.2)) {
            shrinking = true
        }
        try? await Task.sleep(for: .milliseconds(200))
    }
}
