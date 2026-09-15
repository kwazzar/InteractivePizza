//
//  ZoomOverlay.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import SwiftUI

struct ZoomButtonStyle: ButtonStyle {
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

struct ZoomOverlay: View {
    let isActive: Bool
    let image: Image?
    let background: Color
    let geoSize: CGSize
    let onDismiss: () -> Void

    private let pizzaCenterY: CGFloat = 250

    var body: some View {
        if isActive, let image {
            let anchorY = geoSize.height > 0 ? pizzaCenterY / geoSize.height : 0.3

            ZStack {
                background.ignoresSafeArea()
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geoSize.width, height: geoSize.height)
                    .scaleEffect(1.3)
                    .allowsHitTesting(false)
            }
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture { onDismiss() }
            .gesture(
                MagnificationGesture()
                    .onEnded { _ in onDismiss() }
            )
            .transition(.scale(scale: 0.05, anchor: UnitPoint(x: 0.5, y: anchorY)).combined(with: .opacity))
        }
    }
}
