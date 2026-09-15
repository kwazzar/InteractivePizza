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
    @State private var isZoomed = false
    
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
                    PizzaCarousel(
                        pizzas: viewModel.pizzas,
                        pizzaSize: viewModel.selectedSize ?? .medium,
                        selection: Binding(
                            get: { viewModel.selectedPizza?.id },
                            set: { viewModel.select($0) }
                        ),
                        image: { viewModel.pizzaImage(for: $0) },
                        imageFailed: { viewModel.pizzaImageFailed(for: $0) }
                    )
                    .frame(height: 275)
                    .overlay(alignment: .center) {
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                isZoomed = true
                            }
                        } label: {
                            Image("zoom")
                                .frame(width: 48, height: 48)
                        }
                    }
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
                .padding(.top, 30)
                .padding(.bottom, 15)
                .padding(.horizontal, 10)
            }
            .overlay {
                if isZoomed,
                   let pizza = viewModel.selectedPizza,
                   let image = viewModel.pizzaImage(for: pizza.id) {
                    ZStack {
                        theme.background.ignoresSafeArea()
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 275, height: 275)
                            .clipShape(Circle())
                            .scaleEffect(
                                (geo.size.width * geo.size.width + geo.size.height * geo.size.height).squareRoot() / 275
                            )
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            isZoomed = false
                        }
                    }
                    .transition(.scale(scale: 0.15, anchor: .center))
                }
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
