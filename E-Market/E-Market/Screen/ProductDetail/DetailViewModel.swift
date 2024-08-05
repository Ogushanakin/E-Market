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
    // Properties
    let productImageUrl: String
    let productName: String
    let productDescription: String
    let productPrice: String
    var isInCart: Bool
    
    // Delegate
    weak var delegate: DetailViewModelDelegate?
    
    // Initializer
    init(product: HomeModel, isInCart: Bool) {
        self.productImageUrl = product.image ?? ""
        self.productName = product.name!
        self.productDescription = product.description!
        self.productPrice = "\(String(describing: product.price))₺"
        self.isInCart = isInCart
    }
    
    func toggleCartStatus() {
        isInCart.toggle()
        // Notify delegate about the change
        let buttonTitle = isInCart ? "Remove from Cart" : "Add to Cart"
        delegate?.didUpdateButtonTitle(buttonTitle)
    }
}
