//
//  Service.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import UIKit

class ProductService {
    static let shared = ProductService()
    private var currentPage = 0
    private let itemsPerPage = 4
    
    init() {}
    
    // Fetch products with pagination
    func fetchMoreProducts(completion: @escaping ([HomeModel]?) -> Void) {
        currentPage += 1
        
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products?page=\(currentPage)&limit=\(itemsPerPage)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([HomeModel].self, from: data)
                completion(products)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // Search products with a query
    func searchProducts(query: String, completion: @escaping ([HomeModel]?) -> Void) {
        currentPage = 0 // Reset pagination for new search
        
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products?search=\(query)&limit=\(itemsPerPage)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([HomeModel].self, from: data)
                completion(products)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}


extension UIViewController {
    func showAlert(title: String = "Alert", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
