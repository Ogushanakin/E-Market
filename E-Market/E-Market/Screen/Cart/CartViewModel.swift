//
//  CartViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import Foundation

class CartViewModel {
    
    // MARK: - Properties
    private let cartManager = CartManager.shared
    
    var cartItems: [Product] {
        return cartManager.cartItems
    }
    
    // Notify view controller when cart items are updated
    var onCartUpdated: (() -> Void)?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartDidUpdate), name: cartManager.cartDidUpdateNotification, object: nil)
    }
    
    @objc private func cartDidUpdate() {
        onCartUpdated?()
    }
    
    func getTotalPrice() -> String {
        let total = cartItems.reduce(0.0) { result, item in
            guard let price = Double(item.price ?? "0") else { return result }
            return result + price * Double(item.count)
        }
        return String(format: "%.2f", total)
    }
    
    func increaseQuantity(for product: Product) {
        var updatedProduct = product
        updatedProduct.count += 1
        cartManager.addToCart(item: updatedProduct)
    }
    
    func decreaseQuantity(for product: Product) {
        var updatedProduct = product
        if updatedProduct.count > 1 {
            updatedProduct.count -= 1
            cartManager.addToCart(item: updatedProduct)
        } else {
            cartManager.removeFromCart(item: updatedProduct)
        }
    }
}
