//
//  HomeView.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct HomeView: View {
    @State var ViewModel: HomeViewModel
    @Environment(ThemeManager.self) private var theme
    @State private var appeared = false
    @State private var selectedIndex = 0
    @State private var pizzaName = "Pepperoni Blast"
    @State private var description: String = "The combination of perfectly melted mozzarella \ncheese, tangy tomato sauce, and a crispy yet \nchewy crust creates a harmonious balance that \nleaves you wanting more."

    private var selectedPizza: Pizza? {
        guard ViewModel.pizzas.indices.contains(selectedIndex) else { return nil }
        return ViewModel.pizzas[selectedIndex]
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                HomeNavbar(pizzaName: $pizzaName,
                           backAction: { },
                           heartAction: { })
                if ViewModel.isLoading {
                    ProgressView()
                        .frame(height: 275)
                } else if let pizza = selectedPizza {
                    PizzaSelector(pizza: pizza)
                }
                Spacer()
                SizeSelector()
           
                Text(description)
                    .font(.figtree(.regular, size: 14))
                    .lineSpacing(10)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 15)
                    
                
                OrderLine()
                    .padding(.bottom, 15)
                    .padding(.horizontal, 10)
            }
            .background(
                ZStack {
                    theme.background
                    Circle()
                        .fill(theme.highlight)
                        .frame(width: 607, height: 607)
                        .position(x: geo.size.width / 2, y: 250)
                }
                    .ignoresSafeArea()
            )
        }
        .task {
            await ViewModel.load()
        }
        .onChange(of: ViewModel.pizzas.count) { _, _ in
            syncSelectedPizza()
        }
    }

    private func syncSelectedPizza() {
        guard let pizza = selectedPizza else { return }
        pizzaName = pizza.name
        description = pizza.description
    }
}

#Preview {
    HomeView(ViewModel: HomeViewModel())
        .environment(ThemeManager())
}
