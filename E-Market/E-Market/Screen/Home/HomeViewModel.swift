//
//  HomeViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

class HomeViewModel {
    private let productService: ProductServiceProtocol
    var homeModels: [Product] = []
    
    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }
    
    func fetchMoreProducts(completion: @escaping (Result<Void, Error>) -> Void) {
        productService.fetchMoreProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.homeModels.append(contentsOf: products)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchProducts(query: String, completion: @escaping (Result<Void, Error>) -> Void) {
        productService.searchProducts(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.homeModels = products
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func filterProducts(by brands: Set<String>, completion: @escaping (Result<Void, Error>) -> Void) {
        productService.fetchAllProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.homeModels = products.filter { brands.contains($0.brand ?? "") }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addToCart(product: Product, completion: @escaping (Bool) -> Void) {
        if CartManager.shared.isProductInCart(product) {
            CartManager.shared.removeFromCart(item: product)
            completion(false)
        } else {
            CartManager.shared.addToCart(item: product)
            completion(true)
        }
    }
    
    func addToFavorites(product: Product, completion: @escaping (Bool) -> Void) {
        if FavoriteManager.shared.isProductInCart(product) {
            FavoriteManager.shared.removeFromCart(item: product)
            completion(false)
        } else {
            FavoriteManager.shared.addToCart(item: product)
            completion(true)
        }
    }
}
