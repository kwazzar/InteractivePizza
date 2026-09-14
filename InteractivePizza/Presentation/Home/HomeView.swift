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
    @State private var pizzaName = "Pepperoni Blast"
    @State private var description: String = "This pizza showcases the perfect combination of shrimp and cheese, with gooey melted cheeses complementing the savory shrimp toppings for a truly indulgent experience."

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HomeNavbar(pizzaName: $pizzaName,
                           backAction: { },
                           heartAction: { })
                Spacer()
                Spacer()
                Spacer()
                Text(description)
                    .font(.figtree(.regular, size: 14))
                    .lineSpacing(10)
                    .padding(.horizontal, 10)
                    Spacer()
                OrderLine()
                    .padding(.bottom)
                    .padding(.horizontal, 10)
            }
            .background(
                ZStack {
                    theme.background
                    Circle()
                        .fill(theme.highlight)
                        .frame(width: 607, height: 607)
                        .position(x: geo.size.width / 2, y: 220)
                }
                .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    HomeView()
        .environment(ThemeManager())
}
