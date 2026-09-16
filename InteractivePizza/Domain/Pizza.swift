//
//  Pizza.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

struct Pizza: Identifiable {
    let id: String
    let name: String
    let description: String
    let imageURL: String
    let defaultSize: PizzaSize
    let variants: [PizzaVariant]
}

struct PizzaVariant {
    let size: PizzaSize
    let price: Double
}

enum PizzaSize: String, CaseIterable {
    case small = "S"
    case medium = "M"
    case large = "L"
}
