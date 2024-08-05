//
//  CartManager.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation
import UIKit

class CartManager {
    static let shared = CartManager()
    
    private let cartKey = "cart"
    let cartDidUpdateNotification = Notification.Name("CartDidUpdate")
    
    private init() {}
    
    var cartItems: [HomeModel] {
        return getCart()
    }
    
    func addToCart(item: HomeModel) {
        var currentCart = getCart()
        if let index = currentCart.firstIndex(where: { $0.id == item.id }) {
            // Eğer ürün zaten varsa, miktarı artır
            currentCart[index].count += 1
        } else {
            // Yeni ürün ekle
            var newItem = item
            newItem.count = 1
            currentCart.append(newItem)
        }
        saveCart(cart: currentCart)
        NotificationCenter.default.post(name: cartDidUpdateNotification, object: nil)
    }
    
    func removeFromCart(item: HomeModel) {
        var currentCart = getCart()
        if let index = currentCart.firstIndex(where: { $0.id == item.id }) {
            // Eğer miktar 1'den büyükse, miktarı azalt
            if currentCart[index].count > 1 {
                currentCart[index].count -= 1
            } else {
                // Miktar 1 ise, ürünü listeden çıkar
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
    
    private func getCart() -> [HomeModel] {
        if let data = UserDefaults.standard.data(forKey: cartKey) {
            do {
                let decoder = JSONDecoder()
                let cart = try decoder.decode([HomeModel].self, from: data)
                return cart
            } catch {
                print("Error decoding cart: \(error)")
            }
        }
        return []
    }
    
    private func saveCart(cart: [HomeModel]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(cart)
            UserDefaults.standard.set(data, forKey: cartKey)
        } catch {
            print("Error encoding cart: \(error)")
        }
    }
    
    func isProductInCart(_ product: HomeModel) -> Bool {
        let currentCart = getCart()
        return currentCart.contains { $0.id == product.id }
    }
}
