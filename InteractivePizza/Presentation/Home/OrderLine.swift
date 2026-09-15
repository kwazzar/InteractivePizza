//
//  OrderLine.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI

struct OrderLine: View {
    @Environment(ThemeManager.self) private var theme
    @Binding var quantity: Int
    var price: String
    var onAdd: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 8) {
            amountSelector
            
            Text(price)
                .font(.figtree(.black, size: 24))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .layoutPriority(1)
                .padding(.horizontal, priceHorizontalPadding)
            
            Button(action: { onAdd?() }) {
                Text(textButton)
                    .font(.figtree(.black, size: buttonFontSize))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .frame(height: 48)
                    .padding(.horizontal)
                    .background(theme.accent, in: Capsule())
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
    }
}

private extension OrderLine {
    
    var amountSelector: some View {
        HStack(spacing: selectorSpacing) {
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
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(width: quantityWidth)

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
        .padding(.horizontal, selectorHorizontalPadding)
        .frame(height: 48)
        .background(theme.highlight, in: Capsule())
    }
}

extension OrderLine {
    private var priceHorizontalPadding: CGFloat {
        switch price.count {
        case 0...4: return 20
        case 5...6: return 8
        default: return 4
        }
    }
    
    private var buttonFontSize: CGFloat {
        quantity >= 100 ? 18 : 24
    }
    
    private var quantityWidth: CGFloat {
        CGFloat(max(String(quantity).count, 1)) * 14 + 10
    }
    
    private var selectorSpacing: CGFloat {
        quantity >= 100 ? 8 : 12
    }
    
    private var selectorHorizontalPadding: CGFloat {
        quantity >= 100 ? 6 : 0
    }
    
    private var textButton: String {
        quantity >= 100 ? "Pizza" : "Add"
    }
}

#Preview {
    OrderLine(quantity: .constant(1), price: "$18.00")
        .environment(ThemeManager())
}
