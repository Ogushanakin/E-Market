//
//  FilterManager.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import Foundation

protocol FilterManagerProtocol {
    var allData: [Product] { get set }
    var brandSelected: Set<String>  { get set }
    var modelSelected: Set<String>  { get set }
}

class FilterManager: NSObject, FilterManagerProtocol {
    internal static var shared = FilterManager()
    
    var allData: [Product] = []
    var brandSelected: Set<String> = []
    var modelSelected: Set<String> = []
    
    private override init() {
        super.init()
    }
}

import Foundation

// MARK: - Product
struct Product: Codable, Hashable {
    let createdAt: String?
    let name: String?
    let image: String?
    let price: String?
    let description: String?
    let model: String?
    let brand: String?
    let id: String?
    var numberOfCart: Int? = 0
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

import Foundation

struct FilterModel: Hashable, Comparable {
    let name: String
    var isChecked: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: FilterModel, rhs: FilterModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: FilterModel, rhs: FilterModel) -> Bool {
        lhs.name < rhs.name
    }
}
