//
//  ApiPizza.swift
//  InteractivePizza
//
//  Created by kwazzar on 15.09.2026.
//

struct PizzasResponse: Decodable {
    let pizzas: [ApiPizza]
}

struct ApiPizza: Decodable {
    let id: String
    let name: String
    let description: String
    let imageURL: String
    let variants: [Variant]
    let defaultSize: String


    struct Variant: Decodable {
        let size: String
        let price: Double
    }

    enum CodingKeys: String, CodingKey {
        case id, name, description, variants
        case imageURL = "image_url"
        case defaultSize = "default_size"

    }
}
