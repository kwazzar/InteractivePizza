//
//  HomeNavbar.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct HomeNavbar: View {
    @Environment(ThemeManager.self) private var theme
    
    @Binding var pizzaName: String
    var backAction: () -> Void
    var heartAction: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            Text("Pizzas")
                .font(.figtree(.regular, size: 14))
                .foregroundStyle(.black.opacity(0.7))
            Text(pizzaName)
                .font(.figtree(.medium, size: 24))
                .foregroundStyle(theme.active)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(theme.highlight.ignoresSafeArea(edges: .top))
        .overlay(alignment: .leading) {
            CircleButton(icon: "NavbarIconBack", action: { backAction() })
                .padding(.leading, 24)
        }
        .overlay(alignment: .trailing) {
            CircleButton(icon: "NavbarIconHeart", action: { heartAction() })
                .padding(.trailing, 24)
        }
    }
}

struct CircleButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
        }
    }
}
