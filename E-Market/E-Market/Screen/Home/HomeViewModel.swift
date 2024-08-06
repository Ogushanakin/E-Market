//
//  HomeViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

class HomeViewModel {
    private let productService: ProductServiceProtocol
    var homeModels: [HomeModel] = []
    
    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }

    func fetchMoreProducts(completion: @escaping (Result<Void, Error>) -> Void) {
        productService.fetchMoreProducts { result in
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
        productService.searchProducts(query: query) { result in
            switch result {
            case .success(let products):
                self.homeModels = products
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
