//
//  Pizza.swift
//  InteractivePizza
//
//  Created by kwazzar on 14.09.2026.
//

struct Pizza {
    var id: String
    var name: String
    var description: String
    var imageURL: String
    var amount: Int
    var price: Int
}

struct PizzaVariant: Decodable {
    var size: String
    var price: Double
}

struct PizzasResponse: Decodable {
    var pizzas: [PizzaAPI]
}

struct PizzaAPI: Decodable {
    var id: String
    var name: String
    var description: String
    var imageURL: String
    var variants: [PizzaVariant]

    enum CodingKeys: String, CodingKey {
        case id, name, description, variants
        case imageURL = "image_url"
    }
}

enum PizzaSource {
    case api([Pizza])          // дані з мережі
    case local([Pizza])        // локальні Pizza піци
}
