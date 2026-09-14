//
//  HomeView.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct HomeView: View {
    @Environment(ThemeManager.self) private var theme
    @State private var appeared = false

    var body: some View {
        Text("Pizzas")
            .font(.title.bold())
            .foregroundStyle(theme.active)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(y: appeared ? 0 : 80)
            .opacity(appeared ? 1 : 0)
            .background(theme.highlight.ignoresSafeArea())
            .onAppear {
                withAnimation(.easeOut(duration: 0.35)) {
                    appeared = true
                }
            }
    }
}