//
//  CartModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

struct CartModel {
    var name: String
    var price: Double
    var id: UUID
    var count: Int

    init(name: String, price: Double, id: UUID, count: Int) {
        self.name = name
        self.price = price
        self.id = id
        self.count = count
    }
}
