//
//  FavoriteManager.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import CoreData

class FavoriteManager {
    static let shared = FavoriteManager()
    
    private let cartKey = "favorites"
    let cartDidUpdateNotification = Notification.Name("FavoriteDidUpdate")
    
    private init() {}
    
    var cartItems: [Product] {
        return getFavorites()
    }
    
    func addToFavorite(item: Product) {
        var currentCart = getFavorites()
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
    
    func removeFromFavorite(item: Product) {
        var currentCart = getFavorites()
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
    
    private func getFavorites() -> [Product] {
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
    
    func isProductInFavorites(_ product: Product) -> Bool {
        let currentCart = getFavorites()
        return currentCart.contains { $0.id == product.id }
    }
}
