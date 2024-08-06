//
//  DetailViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func didUpdatePrice(_ price: String)
    func didUpdateButtonTitle(_ title: String)
}

class DetailViewModel {

    let product: Product
    private(set) var isInCart: Bool {
        didSet {
            // Notify delegate about the button title change
            delegate?.didUpdateButtonTitle(isInCart ? "Remove from Cart" : "Add to Cart")
        }
    }
    
    // Computed properties for easy access
    var productImageUrl: String { product.image ?? "" }
    var productName: String { product.name ?? "" }
    var productDescription: String { product.description ?? "" }
    var productPrice: String { "\(product.price ?? "0")₺" }
    
    // Delegate
    weak var delegate: DetailViewModelDelegate?
    
    // Initializer
    init(product: Product, isInCart: Bool) {
        self.product = product
        self.isInCart = isInCart
    }
    
    func toggleCartStatus() {
        isInCart.toggle()
        
        // Perform the cart operation based on the new status
        if isInCart {
            CartManager.shared.addToCart(item: product)
        } else {
            CartManager.shared.removeFromCart(item: product)
        }
        
        // Notify delegate about the button title change
        delegate?.didUpdateButtonTitle(isInCart ? "Remove from Cart" : "Add to Cart")
        
        // Optionally update the price or other properties if needed
        // delegate?.didUpdatePrice(productPrice) // Uncomment if needed
    }
}
