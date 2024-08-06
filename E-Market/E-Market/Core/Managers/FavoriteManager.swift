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
    
    var cartItems: [HomeModel] {
        return getFavorites()
    }
    
    func addToCart(item: HomeModel) {
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

    
    func removeFromCart(item: HomeModel) {
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
    
    private func getFavorites() -> [HomeModel] {
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
        let currentCart = getFavorites()
        return currentCart.contains { $0.id == product.id }
    }
}
