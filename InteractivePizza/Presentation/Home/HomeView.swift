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
                    ZStack {
                        PizzaCarousel(
                            pizzas: viewModel.pizzas,
                            pizzaSize: viewModel.selectedSize ?? .medium,
                            selection: Binding(
                                get: { viewModel.selectedPizza?.id },
                                set: { viewModel.select($0) }
                            ),
                            image: { viewModel.pizzaImage(for: $0) },
                            imageFailed: { viewModel.pizzaImageFailed(for: $0) },
                            onPinchZoom: { toggleZoom(true) },
                            isZoomed: isZoomed
                        )
                        .frame(height: 275)

                        Button {
                            toggleZoom(!isZoomed)
                        } label: {
                            Image("zoom")
                                .scaledToFill()
                                .frame(width: 88, height: 88)
                        }
                        .buttonStyle(ZoomButtonStyle(isZoomed: isZoomed))
                        .zIndex(1)
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
                    onAdd: { }
                )
                .padding(.top, 30)
                .padding(.bottom, 15)
                .padding(.horizontal, 10)
            }
            .overlay {
                if isZoomed,
                   let pizza = viewModel.selectedPizza,
                   let image = viewModel.pizzaImage(for: pizza.imageURL) {
                    let pizzaCenterY: CGFloat = 250
                    let anchorY = geo.size.height > 0 ? pizzaCenterY / geo.size.height : 0.3

                    ZStack {
                        theme.background.ignoresSafeArea()
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .scaleEffect(1.3)
                            .allowsHitTesting(false)
                    }
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture { toggleZoom(false) }
                    .gesture(
                        MagnificationGesture()
                            .onEnded { _ in
                                toggleZoom(false)
                            }
                    )
                    .transition(.scale(scale: 0.05, anchor: UnitPoint(x: 0.5, y: anchorY)).combined(with: .opacity))
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

    private func toggleZoom(_ open: Bool) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
            isZoomed = open
        }
    }
}

extension Double {
    var asUSD: String {
        String(format: "$%.2f", self)
    }
}

private struct ZoomButtonStyle: ButtonStyle {
    let isZoomed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : (isZoomed ? 1.12 : 1.0))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .rotationEffect(.degrees(configuration.isPressed ? -8 : (isZoomed ? 180 : 0)))
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isZoomed)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
        .environment(ThemeManager())
}
