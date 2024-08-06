//
//  MockProductService.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import Foundation

protocol ProductServiceProtocol {
    func fetchMoreProducts(completion: @escaping (Result<[HomeModel], Error>) -> Void)
    func searchProducts(query: String, completion: @escaping (Result<[HomeModel], Error>) -> Void)
}

class MockProductService: ProductServiceProtocol {
    var shouldReturnError = false
    var productsToReturn: [HomeModel] = []

    func fetchMoreProducts(completion: @escaping (Result<[HomeModel], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
            completion(.success(productsToReturn))
        }
    }

    func searchProducts(query: String, completion: @escaping (Result<[HomeModel], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])))
        } else {
            completion(.success(productsToReturn))
        }
    }
}
