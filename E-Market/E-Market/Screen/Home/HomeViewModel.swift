//
//  HomeViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

class HomeViewModel {
    
    private let productService = ProductService()
    var homeModels: [HomeModel] = []
    
    func fetchMoreProducts(completion: @escaping () -> Void) {
        productService.fetchMoreProducts { [weak self] newProducts in
            guard let self = self else {
                completion()
                return
            }
            if let newProducts = newProducts {
                self.homeModels.append(contentsOf: newProducts)
            }
            completion()
        }
    }
    
    func searchProducts(query: String, completion: @escaping () -> Void) {
        productService.searchProducts(query: query) { [weak self] products in
            guard let self = self else {
                completion()
                return
            }
            self.homeModels = products ?? []
            completion()
        }
    }
}
