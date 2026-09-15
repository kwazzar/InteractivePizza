//
//  Font+Figtree.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

import SwiftUI

extension Font {
    enum FigtreeWeight {
        case light, regular, medium, bold, black

        var fontWeight: Font.Weight {
            switch self {
            case .light:    return .light
            case .regular:  return .regular
            case .medium:   return .medium
            case .bold:     return .bold
            case .black:    return .black
            }
        }
    }

    static func figtree(_ weight: FigtreeWeight = .regular, size: CGFloat) -> Font {
        .custom("Figtree", size: size).weight(weight.fontWeight)
    }
}
