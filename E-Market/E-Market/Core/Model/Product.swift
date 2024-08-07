//
//  Product.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

struct Product: Codable, Equatable {
    let createdAt: String?
    let name: String?
    let image: String?
    let price: String?
    let description: String?
    let model: String?
    let brand: String?
    let id: String?
    var count: Int

    enum CodingKeys: String, CodingKey {
        case createdAt
        case name
        case image
        case price
        case description
        case model
        case brand
        case id
        case count
    }

    init(createdAt: String? = nil, name: String? = nil, image: String? = nil, price: String? = nil, description: String? = nil, model: String? = nil, brand: String? = nil, id: String? = nil, count: Int = 1) {
        self.createdAt = createdAt
        self.name = name
        self.image = image
        self.price = price
        self.description = description
        self.model = model
        self.brand = brand
        self.id = id
        self.count = count
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        model = try values.decodeIfPresent(String.self, forKey: .model)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        count = try values.decodeIfPresent(Int.self, forKey: .count) ?? 1
    }

    // Optional: Convert price to Double for sorting
    var priceAsDouble: Double? {
        return Double(price ?? "")
    }
}
