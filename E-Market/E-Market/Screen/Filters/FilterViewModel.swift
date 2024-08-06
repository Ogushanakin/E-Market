//
//  FilterViewModel.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import Foundation

protocol FilterViewModelProtocol: AnyObject {
    func viewDidLoad()
    func viewWillDisappear()
    func sortButtonsTapped(tag: Int)
    func finisFilterTapped()
    
    var brand: InnerFilterViewModelProtocol { get }
    var model: InnerFilterViewModelProtocol { get }
}

protocol InnerFilterViewModelProtocol {
    var itemsCount: Int { get }
    func searchBarTextDidChange(_ text: String, completion: @escaping () -> Void)
    func item(at index: Int) -> FilterModel
    func selectedRow(at index: Int)
    func saveSelected()
}

protocol FilterViewControllerProtocol: AnyObject {
    func reload()
}

class FilterViewModel {
    
    var sortBy: FilterSortBy = .newToOld
    var didDismiss: (() -> ())?
    
    var brand: InnerFilterViewModelProtocol = Brand()
    var model: InnerFilterViewModelProtocol = Model()
    
    unowned var view: FilterViewControllerProtocol
    
    init(view: FilterViewControllerProtocol) {
        self.view = view
    }
}

extension FilterViewModel: FilterViewModelProtocol {
    func viewDidLoad() {
        view.reload()
    }
    
    func viewWillDisappear() {
        didDismiss?()
    }
    
    func sortButtonsTapped(tag: Int) {
        sortBy = FilterSortBy(rawValue: tag) ?? .oldToNew
    }
    
    func finisFilterTapped() {
        brand.saveSelected()
        model.saveSelected()
    }
    
    enum FilterSortBy: Int {
        case oldToNew
        case newToOld
        case priceHightToLow
        case priceLowToHigh
    }
}

class InnerFilterViewModel: InnerFilterViewModelProtocol {
    var array: [FilterModel] = []
    var searchedArray: [FilterModel] = []
    var selecteds: Set<String> = []
    
    lazy var filterManager: FilterManagerProtocol = {
        return FilterManager.shared
    }()
    
    fileprivate init() {
        loadArray()
    }
    
    var itemsCount: Int {
        searchedArray.count
    }

    func item(at index: Int) -> FilterModel {
        searchedArray[index]
    }
    
    func searchBarTextDidChange(_ text: String, completion: @escaping () -> Void) {
        if text.isEmpty {
            searchedArray = array
        } else {
            searchedArray = array.filter { item in
                return item.name.lowercased().contains(text.lowercased())
            }
        }
        completion()
    }
    
    func selectedRow(at index: Int) {
        let item = item(at: index)
        var result = false
        if selecteds.contains(item.name) {
            selecteds.remove(item.name)
        } else {
            selecteds.insert(item.name)
            result = true
        }
        searchedArray[index] = .init(name: item.name, isChecked: result)
        if let index = array.firstIndex(where: { $0 == item }) {
            array[index] = .init(name: item.name, isChecked: result)
        }
    }
    
    func saveSelected() {}
    func loadArray() {}
}

class Brand: InnerFilterViewModel {
    override func saveSelected() {
        filterManager.brandSelected = selecteds
    }
    
    override func loadArray() {
        selecteds = filterManager.brandSelected
        let allData = filterManager.allData
        array = Set(allData.compactMap{ $0.brand })
            .map{FilterModel(name: $0, isChecked: selecteds.contains($0)) }
        array.sort()
        searchedArray = array
    }
}

class Model: InnerFilterViewModel {
    override func saveSelected() {
        filterManager.modelSelected = selecteds
    }
    
    override func loadArray() {
        selecteds = filterManager.modelSelected
        let allData = filterManager.allData
        array = Set(allData.compactMap{ $0.model })
            .map{FilterModel(name: $0, isChecked: selecteds.contains($0)) }
        array.sort()
        searchedArray = array
    }
}

