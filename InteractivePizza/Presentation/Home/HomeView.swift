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
    @State private var showZoomButton = true
    @State private var appeared = false
    
    private let entryAnimation = Animation.spring(response: 0.45, dampingFraction: 0.82)
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                HomeNavbar(
                    pizzaName: .constant(viewModel.pizzaName),
                    backAction: { },
                    heartAction: { }
                )
                .modifier(FlyInModifier(delay: 0, direction: .top, appeared: appeared))
                
                
                ZStack {
                    if viewModel.pizzas.isEmpty {
                        PizzaCarouselPlaceholder()
                    } else {
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
                    }
                    
                    ZoomButton(isZoomed: $isZoomed,
                               toggleZoom: toggleZoom)
                    .opacity(showZoomButton ? 1 : 0)
                }
                .modifier(FlyInModifier(delay: 1, direction: .bottom, appeared: appeared))
                .animation(.spring(response: 0.35, dampingFraction: 0.75), value: viewModel.selectedSize)
                .onChange(of: viewModel.selectedPizza?.id) { _, _ in
                    showZoomButton = false
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(0.35))
                        showZoomButton = true
                    }
                }
                
                Spacer()
                
                SizeSelector(selectedSize: Binding(
                    get: { viewModel.selectedSize },
                    set: { viewModel.selectedSize = $0 }
                ))
                .modifier(FlyInModifier(delay: 2, direction: .bottom, appeared: appeared))
                
                Text(viewModel.description)
                    .font(.figtree(.regular, size: 14))
                    .lineSpacing(10)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 15)
                    .modifier(FlyInModifier(delay: 3, direction: .bottom, appeared: appeared))
                
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
                .modifier(FlyInModifier(delay: 4, direction: .bottom, appeared: appeared))
            }
            .overlay {
                ZoomOverlay(
                    isActive: isZoomed,
                    image: viewModel.selectedPizza.flatMap { viewModel.pizzaImage(for: $0.imageURL) },
                    background: theme.background,
                    geoSize: geo.size,
                    onDismiss: { toggleZoom(false) }
                )
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
            withAnimation(entryAnimation) {
                appeared = true
            }
        }
    }
    
    private func toggleZoom(_ open: Bool) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.78)) {
            isZoomed = open
        }
    }
}

struct PizzaCarouselPlaceholder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 275)
            .overlay {
                ProgressView()
            }
    }
}

private struct FlyInModifier: ViewModifier {
    enum Direction { case top, bottom, left, right }
    
    let delay: Int
    let direction: Direction
    let appeared: Bool
    
    private var offset: CGSize {
        guard !appeared else { return .zero }
        switch direction {
        case .top:    return CGSize(width: 0, height: -60)
        case .bottom: return CGSize(width: 0, height: 60)
        case .left:   return CGSize(width: -60, height: 0)
        case .right:  return CGSize(width: 60, height: 0)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(offset)
            .animation(
                .spring(response: 0.5, dampingFraction: 0.8)
                .delay(Double(delay) * 0.06),
                value: appeared
            )
    }
}

extension Double {
    var asUSD: String {
        String(format: "$%.2f", self)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(
        manager: PizzaManager(dataSource: InMemoryPizzaDataSource(), service: PizzaService())
    ))
    .environment(ThemeManager())
}
