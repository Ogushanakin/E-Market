//
//  HomeViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

class HomeViewModel {
    
    private let productService = ProductService.shared
    var homeModels: [HomeModel] = []
    
    func fetchMoreProducts(completion: @escaping (Result<Void, Error>) -> Void) {
        productService.fetchMoreProducts { [weak self] result in
            guard let self = self else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ViewModel deallocated"])))
                return
            }
            
            switch result {
            case .success(let newProducts):
                self.homeModels.append(contentsOf: newProducts)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchProducts(query: String, completion: @escaping (Result<Void, Error>) -> Void) {
        productService.searchProducts(query: query) { [weak self] result in
            guard let self = self else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ViewModel deallocated"])))
                return
            }
            
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
