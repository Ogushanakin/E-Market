//
//  DetailViewModelTest.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class DetailViewModelTests: XCTestCase {

    var viewModel: DetailViewModel!
    var mockDelegate: MockDetailViewModelDelegate!
    
    override func setUpWithError() throws {
        let product = Product(name: "Test Product", image: nil, price: "100", description: "Test Description")
        viewModel = DetailViewModel(product: product, isInCart: false)
        mockDelegate = MockDetailViewModelDelegate()
        viewModel.delegate = mockDelegate
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockDelegate = nil
    }

    func testToggleCartStatus() throws {
        viewModel.toggleCartStatus()
        XCTAssertTrue(viewModel.isInCart)
        XCTAssertEqual(mockDelegate.updatedButtonTitle, "Remove from Cart")
        
        viewModel.toggleCartStatus()
        XCTAssertFalse(viewModel.isInCart)
        XCTAssertEqual(mockDelegate.updatedButtonTitle, "Add to Cart")
    }
    
    func testUpdatePrice() throws {
        viewModel.delegate?.didUpdatePrice(viewModel.productPrice)
        // Here you would verify if the price is updated in the delegate
        // e.g. XCTAssertEqual(mockDelegate.updatedPrice, viewModel.productPrice)
    }
}

// MARK: - Mocks
class MockDetailViewModelDelegate: DetailViewModelDelegate {
    var updatedButtonTitle: String?
    var updatedPrice: String?
    
    func didUpdatePrice(_ price: String) {
        updatedPrice = price
    }
    
    func didUpdateButtonTitle(_ title: String) {
        updatedButtonTitle = title
    }
}
