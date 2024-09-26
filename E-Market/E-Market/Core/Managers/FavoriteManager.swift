//
//  FavoriteManager.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import CoreData

protocol FavoriteManaging {
    func addToFavorite(item: Product)
    func removeFromFavorite(item: Product)
    func clearFavorites()
    func isProductInFavorites(_ product: Product) -> Bool
    var favorites: [Product] { get }
}

class FavoriteManager: FavoriteManaging {
    private let favoritesKey = "favorites"
    let favoritesDidUpdateNotification = Notification.Name("FavoriteDidUpdate")
    
    var favorites: [Product] {
        return getFavorites()
    }
    
    func addToFavorite(item: Product) {
        var currentFavorites = getFavorites()
        if !currentFavorites.contains(where: { $0.id == item.id }) {
            currentFavorites.append(item)
            saveFavorites(favorites: currentFavorites)
            NotificationCenter.default.post(name: favoritesDidUpdateNotification, object: nil)
        }
    }
    
    func removeFromFavorite(item: Product) {
        var currentFavorites = getFavorites()
        currentFavorites.removeAll { $0.id == item.id }
        saveFavorites(favorites: currentFavorites)
        NotificationCenter.default.post(name: favoritesDidUpdateNotification, object: nil)
    }
    
    func clearFavorites() {
        saveFavorites(favorites: [])
        NotificationCenter.default.post(name: favoritesDidUpdateNotification, object: nil)
    }
    
    // MARK: - Private Methods
    
    private func getFavorites() -> [Product] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {
            do {
                let decoder = JSONDecoder()
                let favorites = try decoder.decode([Product].self, from: data)
                return favorites
            } catch {
                print("Error decoding favorites: \(error)")
            }
        }
        return []
    }
    
    private func saveFavorites(favorites: [Product]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favorites)
            UserDefaults.standard.set(data, forKey: favoritesKey)
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
    
    func isProductInFavorites(_ product: Product) -> Bool {
        return getFavorites().contains { $0.id == product.id }
    }
}
