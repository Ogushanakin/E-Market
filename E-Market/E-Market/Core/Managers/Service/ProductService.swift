//
//  Service.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import Foundation

class ProductService: ProductServiceProtocol {
    
    static let shared = ProductService()
    private var currentPage = 0
    private let itemsPerPage = 4
    
    private init() {}
    
    func fetchMoreProducts(completion: @escaping (Result<[HomeModel], Error>) -> Void) {
        currentPage += 1
        
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products?page=\(currentPage)&limit=\(itemsPerPage)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([HomeModel].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func searchProducts(query: String, completion: @escaping (Result<[HomeModel], Error>) -> Void) {
        currentPage = 0
        
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products?search=\(query)&limit=\(itemsPerPage)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        NetworkManager.shared.fetch(url: url, responseType: [HomeModel].self) { result in
            switch result {
            case .success(let products):
                completion(.success(products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
