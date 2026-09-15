//
//  PizzaSelector.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import SwiftUI

struct PizzaSelector: View {
    let pizzaSize: PizzaSize
    let image: Image?
    let hasFailed: Bool

    var body: some View {
        Group {
            if let image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: pizzaSize.imageSize, height: pizzaSize.imageSize)
            } else if hasFailed {
                fallback
            } else {
                ProgressView()
                    .frame(width: pizzaSize.imageSize, height: pizzaSize.imageSize)
            }
        }
        .frame(width: 275, height: 275)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: pizzaSize)
    }

    private var fallback: some View {
        Text("Pizza not available")
            .font(.figtree(.medium, size: 18))
    }
}
