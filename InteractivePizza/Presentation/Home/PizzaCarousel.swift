//
//  PizzaCarousel.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import SwiftUI

private extension PizzaSize {
    var scaleRatio: CGFloat {
        switch self {
        case .small:  return 0.71
        case .medium: return 0.87
        case .large:  return 1.0
        }
    }
}

struct PizzaCarousel: View {
    let pizzas: [Pizza]
    let pizzaSize: PizzaSize
    @Binding var selection: Pizza.ID?
    let image: (String) -> Image?
    let imageFailed: (String) -> Bool

    @State private var scrolledID: Pizza.ID?

    private let slot: CGFloat = 80
    private let spacing: CGFloat = 115
    private let hero: CGFloat = 275

    init(
        pizzas: [Pizza],
        pizzaSize: PizzaSize,
        selection: Binding<Pizza.ID?>,
        image: @escaping (String) -> Image?,
        imageFailed: @escaping (String) -> Bool
    ) {
        self.pizzas = pizzas
        self.pizzaSize = pizzaSize
        self._selection = selection
        self.image = image
        self.imageFailed = imageFailed
        _scrolledID = State(initialValue: selection.wrappedValue)
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: spacing) {
                    ForEach(pizzas) { pizza in
                        let minScale = slot / hero
                        let sizeRatio = pizzaSize.scaleRatio

                        tile(for: pizza)
                            .frame(width: slot, height: hero)
                            .padding(.horizontal, 4)
                            .scaleEffect(sizeRatio, anchor: .center)
                            .animation(
                                pizza.id == selection ? .spring(response: 0.35, dampingFraction: 0.75) : nil,
                                value: pizzaSize
                            )
                            .zIndex(pizza.id == selection ? 1 : 0)
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                let t = min(abs(phase.value), 1)
                                let factor = 1 - (1 - minScale / sizeRatio) * t
                                return content.scaleEffect(factor)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, (geo.size.width - slot) / 2, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrolledID)
        }
        .frame(height: hero)
        .onChange(of: selection) { _, new in
            guard let new, new != scrolledID else { return }
            withAnimation(.easeOut(duration: 0.3)) { scrolledID = new }
        }
        .onChange(of: scrolledID) { _, new in
            guard new != selection else { return }
            selection = new
        }
    }

    private func tile(for pizza: Pizza) -> some View {
        ZStack {
            if let image = image(pizza.imageURL) {
                image
                    .resizable()
                    .scaledToFill()
            } else if imageFailed(pizza.imageURL) {
                Text("Pizza not available")
                    .font(.figtree(.medium, size: 18))
                    .minimumScaleFactor(0.5)
            } else {
                ProgressView()
            }
        }
        .frame(width: hero, height: hero)
        .clipShape(Circle())
        .contentShape(Circle())
        .onTapGesture { selection = pizza.id }
    }
}

#Preview {
    PizzaCarousel(
        pizzas: [
            Pizza(id: "1", name: "Margherita", description: "tomato, mozzarella", imageURL: "", amount: 1, defaultSize: .large, variants: []),
            Pizza(id: "2", name: "Pepperoni", description: "pepperoni, cheese", imageURL: "", amount: 1, defaultSize: .large, variants: []),
            Pizza(id: "3", name: "Quattro", description: "four cheeses", imageURL: "", amount: 1, defaultSize: .large, variants: []),
        ],
        pizzaSize: .large,
        selection: .constant("1"),
        image: { _ in nil },
        imageFailed: { _ in false }
    )
    .frame(height: 275)
}