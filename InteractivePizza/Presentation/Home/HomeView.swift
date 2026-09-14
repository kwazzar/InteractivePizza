//
//  InteractivePizzaApp.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct HomeView: View {
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        Text("Pizzas")
            .font(.title.bold())
            .foregroundStyle(theme.active)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(theme.background)
    }
}
