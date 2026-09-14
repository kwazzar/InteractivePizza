//
//  OrderLine.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct OrderLine: View {
    @Environment(ThemeManager.self) private var theme
    @State private var quantity: Int = 1
    var price: String = "$17.99"
    var onAdd: (() -> Void)?

    var body: some View {
        HStack {
            amountSelector
            
            Spacer()
            
            Text(price)
                .font(.figtree(.black, size: 24))
                .foregroundStyle(.black)
            
            Spacer()
            
            Button(action: { onAdd?() }) {
                Text("Add")
                    .font(.figtree(.black, size: 24))
                    .foregroundStyle(.white)
                    .frame(height: 48)
                    .padding(.horizontal, 18)
                    .background(theme.accent, in: Capsule())
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }
}

private extension OrderLine {
    var amountSelector: some View {
        HStack(spacing: 12) {
            Button(action: {
                if quantity > 1 { quantity -= 1 }
            }) {
                Image("minus")
                    .font(.figtree(.bold, size: 16))
                    .foregroundStyle(.black)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(.white)
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                    )
            }

            Text("\(quantity)")
                .font(.figtree(.bold, size: 20))
                .foregroundStyle(.black)
                .frame(minWidth: 20)

            Button(action: {
                quantity += 1
            }) {
                Image("plus")
                    .font(.figtree(.bold, size: 16))
                    .foregroundStyle(.black)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(.white)
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                    )
            }
        }
        .frame(height: 48)
        .background(theme.highlight, in: Capsule())
    }
}

#Preview {
    OrderLine()
        .environment(ThemeManager())
}
