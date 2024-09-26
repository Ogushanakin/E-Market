//
//  HomeViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

final class HomeViewModel {
    private let productService: ProductServiceProtocol
    internal let cartManager: CartManaging
    private let favoriteManager: FavoriteManaging
    var homeModels: [Product] = []
    var sortOption: String?
    var filterBrands: [String] = []
    
    init(productService: ProductServiceProtocol, cartManager: CartManaging, favoriteManager: FavoriteManaging) {
        self.productService = productService
        self.cartManager = cartManager
        self.favoriteManager = favoriteManager
    }
    
    func addToCart(product: Product, completion: @escaping (Bool) -> Void) {
        if cartManager.isProductInCart(product) {
            cartManager.removeFromCart(item: product)
            completion(false)
        } else {
            cartManager.addToCart(item: product)
            completion(true)
        }
    }
    
    func addToFavorites(product: Product, completion: @escaping (Bool) -> Void) {
        if favoriteManager.isProductInFavorites(product) {
            favoriteManager.removeFromFavorite(item: product)
            completion(false)
        } else {
            favoriteManager.addToFavorite(item: product)
            completion(true)
        }
    }
    
    func fetchMoreProducts(completion: @escaping (Result<Void, Error>) -> Void) {
        productService.fetchMoreProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                self.homeModels.append(contentsOf: products)
                self.applySorting()
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
                self.applySorting()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func applySorting() {
        var filteredProducts = homeModels
        
        if !filterBrands.isEmpty {
            filteredProducts = filteredProducts.filter { product in
                guard let brand = product.brand else { return false }
                return filterBrands.contains(brand)
            }
        }
        
        guard let sortOption = sortOption else {
            homeModels = filteredProducts
            return
        }
        
        switch sortOption {
        case "Old to New":
            homeModels = filteredProducts.sorted { product1, product2 in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date1 = dateFormatter.date(from: product1.createdAt ?? "") ?? Date.distantPast
                let date2 = dateFormatter.date(from: product2.createdAt ?? "") ?? Date.distantPast
                return date1 < date2
            }
            
        case "New to Old":
            homeModels = filteredProducts.sorted { product1, product2 in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let date1 = dateFormatter.date(from: product1.createdAt ?? "") ?? Date.distantPast
                let date2 = dateFormatter.date(from: product2.createdAt ?? "") ?? Date.distantPast
                return date1 > date2
            }
            
        case "Price High to Low":
            homeModels = filteredProducts.sorted { product1, product2 in
                let price1 = product1.priceAsDouble ?? 0
                let price2 = product2.priceAsDouble ?? 0
                return price1 > price2
            }
            
        case "Price Low to High":
            homeModels = filteredProducts.sorted { product1, product2 in
                let price1 = product1.priceAsDouble ?? 0
                let price2 = product2.priceAsDouble ?? 0
                return price1 < price2
            }
            
        default:
            homeModels = filteredProducts
        }
    }
}
