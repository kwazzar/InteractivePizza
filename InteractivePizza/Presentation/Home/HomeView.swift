//
//  HomeView.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel
    @Environment(ThemeManager.self) private var theme

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                HomeNavbar(
                    pizzaName: .constant(viewModel.pizzaName),
                    backAction: { },
                    heartAction: { }
                )

                if viewModel.isLoading {
                    ProgressView()
                        .frame(height: 275)
                } else if viewModel.selectedPizza != nil {
                    PizzaSelector(
                        pizzaSize: viewModel.selectedSize ?? .medium,
                        image: viewModel.pizzaImage,
                        hasFailed: viewModel.pizzaImageFailed
                    )
                    .animation(.spring(response: 0.35, dampingFraction: 0.75), value: viewModel.selectedSize)
                }

                Spacer()

                SizeSelector(selectedSize: Binding(
                    get: { viewModel.selectedSize },
                    set: { viewModel.selectedSize = $0 }
                ))

                Text(viewModel.description)
                    .font(.figtree(.regular, size: 14))
                    .lineSpacing(10)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 15)

                OrderLine(
                    quantity: Binding(
                        get: { viewModel.quantity },
                        set: { viewModel.quantity = $0 }
                    ),
                    price: viewModel.selectedPrice.asUSD,
                    onAdd: { /* додати в кошик */ }
                )
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
            await viewModel.load()
        }
        .task(id: viewModel.selectedPizza?.id) {
            guard let imageURL = viewModel.selectedPizza?.imageURL else { return }
            await viewModel.loadPizzaImage(for: imageURL)
        }
    }
}

extension Double {
    var asUSD: String {
        String(format: "$%.2f", self)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
        .environment(ThemeManager())
}
