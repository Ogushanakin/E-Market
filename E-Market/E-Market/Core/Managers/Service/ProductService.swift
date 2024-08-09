//
//  Service.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

protocol ProductServiceProtocol {
    func fetchMoreProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func searchProducts(query: String, completion: @escaping (Result<[Product], Error>) -> Void)
    func fetchAllProducts(completion: @escaping (Result<[Product], Error>) -> Void)
}

class ProductService: ProductServiceProtocol {
    
    static let shared = ProductService()
    private var currentPage = 0
    private let itemsPerPage = 4
    
    public init() {}
    
    func fetchMoreProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        currentPage += 1
        
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products?page=\(currentPage)&limit=\(itemsPerPage)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        NetworkManager.shared.fetch(url: url, responseType: [Product].self) { result in
            switch result {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchProducts(query: String, completion: @escaping (Result<[Product], Error>) -> Void) {
        currentPage = 0
        
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products?search=\(query)&limit=\(itemsPerPage)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        NetworkManager.shared.fetch(url: url, responseType: [Product].self) { result in
            switch result {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        NetworkManager.shared.fetch(url: url, responseType: [Product].self) { result in
            switch result {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
