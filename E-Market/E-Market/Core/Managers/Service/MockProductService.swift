//
//  MockProductService.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import Foundation

protocol ProductServiceProtocol {
    func fetchMoreProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func searchProducts(query: String, completion: @escaping (Result<[Product], Error>) -> Void)
    func fetchAllProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}

class MockProductService: ProductServiceProtocol {
    var shouldReturnError = false
    var productsToReturn: [Product] = []
    
    func fetchMoreProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
            completion(.success(productsToReturn))
        }
    }
    
    func searchProducts(query: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
            let filteredProducts = productsToReturn.filter { product in
                guard let name = product.name else { return false }
                return name.lowercased().contains(query.lowercased())
            }
            completion(.success(filteredProducts))
        }
    }
    
    func fetchAllProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
            completion(.success(productsToReturn))
        }
    }
}
