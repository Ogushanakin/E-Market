//
//  FilterViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import Foundation

protocol FilterViewModelProtocol: AnyObject {
    var brands: [String] { get }
    func fetchBrands(completion: @escaping (Result<Void, Error>) -> Void)
}

final class FilterViewModel: FilterViewModelProtocol {
    private let productService: ProductServiceProtocol
    private(set) var brands: [String] = []
    
    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }

    func fetchBrands(completion: @escaping (Result<Void, Error>) -> Void) {
        productService.fetchAllProducts { result in
            switch result {
            case .success(let products):
                self.brands = self.extractBrands(from: products)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func extractBrands(from products: [Product]) -> [String] {
        let brandSet = Set(products.compactMap { $0.brand }.filter { !$0.isEmpty })
        return Array(brandSet)
    }
}
