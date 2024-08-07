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
            delegate?.didUpdateButtonTitle(isInCart ? "Remove from Cart" : "Add to Cart")
        }
    }
    
    var productImageUrl: String { product.image ?? "" }
    var productName: String { product.name ?? "" }
    var productDescription: String { product.description ?? "" }
    var productPrice: String { "\(product.price ?? "0")₺" }
    
    weak var delegate: DetailViewModelDelegate?
    
    init(product: Product, isInCart: Bool) {
        self.product = product
        self.isInCart = isInCart
    }
    
    func toggleCartStatus() {
        isInCart.toggle()
        
        if isInCart {
            CartManager.shared.addToCart(item: product)
        } else {
            CartManager.shared.removeFromCart(item: product)
        }
        
        delegate?.didUpdateButtonTitle(isInCart ? "Remove from Cart" : "Add to Cart")
    }
}
