//
//  PizzaSelector.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import SwiftUI

struct PizzaSelector: View {
    var pizza: Pizza

    var body: some View {
        VStack {
            if let url = URL(string: pizza.imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image("PepperoniBlast3")
                            .foregroundStyle(.secondary)
                    default:
                        ProgressView()
                    }
                }
            }
        }
        .frame(height: 275)
    }
}
