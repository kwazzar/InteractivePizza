//
//  ThemeManager.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

import SwiftUI
import Observation

@MainActor
@Observable
final class ThemeManager {
    let background: Color
    let highlight: Color
    let accent: Color
    let active: Color

    init(background: Color = Color(hex: 0xFFFFFF),
         highlight: Color = Color(hex: 0xF3E3DA),
         accent: Color = Color(hex: 0x19C4EA),
         active: Color = Color(hex: 0x000000)) {
        self.background = background
        self.highlight = highlight
        self.accent = accent
        self.active = active
    }
}

extension Color {
    nonisolated init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
