//
//  CartManager.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation
import UIKit
import CoreData

protocol CartManaging {
    func addToCart(item: Product)
    func removeFromCart(item: Product)
    func clearCart()
    func isProductInCart(_ product: Product) -> Bool
    var cartItems: [Product] { get }
}

class CartManager: CartManaging {
    private let cartKey = "cart"
    let cartDidUpdateNotification = Notification.Name("CartDidUpdate")
    
    init() {}
    
    var cartItems: [Product] {
        return getCart()
    }
    
    func addToCart(item: Product) {
        var currentCart = getCart()
        if let index = currentCart.firstIndex(where: { $0.id == item.id }) {
            currentCart[index].count += 1
        } else {
            var newItem = item
            newItem.count = 1
            currentCart.append(newItem)
        }
        saveCart(cart: currentCart)
        NotificationCenter.default.post(name: cartDidUpdateNotification, object: nil)
    }
    
    func removeFromCart(item: Product) {
        var currentCart = getCart()
        if let index = currentCart.firstIndex(where: { $0.id == item.id }) {
            if currentCart[index].count > 1 {
                currentCart[index].count -= 1
            } else {
                currentCart.remove(at: index)
            }
            saveCart(cart: currentCart)
            NotificationCenter.default.post(name: cartDidUpdateNotification, object: nil)
        }
    }
    
    func clearCart() {
        saveCart(cart: [])
        NotificationCenter.default.post(name: cartDidUpdateNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func getCart() -> [Product] {
        if let data = UserDefaults.standard.data(forKey: cartKey) {
            do {
                let decoder = JSONDecoder()
                let cart = try decoder.decode([Product].self, from: data)
                return cart
            } catch {
                print("Error decoding cart: \(error)")
            }
        }
        return []
    }
    
    private func saveCart(cart: [Product]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(cart)
            UserDefaults.standard.set(data, forKey: cartKey)
        } catch {
            print("Error encoding cart: \(error)")
        }
    }
    
    func isProductInCart(_ product: Product) -> Bool {
        let currentCart = getCart()
        return currentCart.contains { $0.id == product.id }
    }
}
