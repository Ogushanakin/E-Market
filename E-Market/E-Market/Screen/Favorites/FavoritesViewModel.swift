//
//  FavoritesViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import Foundation

class FavoritesViewModel {
    
    // MARK: - Properties
    private let favoriteManager = FavoriteManager.shared
    
    var favoriteItems: [Product] {
        return favoriteManager.cartItems
    }
    
    var onFavoritesUpdated: (() -> Void)?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesDidUpdate), name: favoriteManager.cartDidUpdateNotification, object: nil)
    }
    
    @objc private func favoritesDidUpdate() {
        onFavoritesUpdated?()
    }
    
    func getTotalFavorites() -> String {
        return "\(favoriteItems.count) items"
    }
    
    func toggleFavorite(for product: Product) {
        if favoriteManager.isProductInFavorites(product) {
            favoriteManager.removeFromFavorite(item: product)
        } else {
            favoriteManager.addToFavorite(item: product)
        }
    }
}
