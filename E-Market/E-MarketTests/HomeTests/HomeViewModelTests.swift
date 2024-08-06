//
//  HomeViewModelTests.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    var mockProductService: MockProductService!

    override func setUp() {
        super.setUp()
        mockProductService = MockProductService()
        viewModel = HomeViewModel(productService: mockProductService)
    }

    override func tearDown() {
        viewModel = nil
        mockProductService = nil
        super.tearDown()
    }

    func testFetchMoreProductsSuccess() {
        // Given
        let expectedProducts = [HomeModel(
            createdAt: nil,
            name: "Test Product",
            image: nil,
            price: "10.0",
            description: nil,
            model: nil,
            brand: nil,
            id: "1",
            count: 1
        )]
        mockProductService.shouldReturnError = false
        mockProductService.productsToReturn = expectedProducts

        // When
        let expectation = self.expectation(description: "Fetch more products")
        viewModel.fetchMoreProducts { result in
            switch result {
            case .success:
                XCTAssertEqual(self.viewModel.homeModels, expectedProducts)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testSearchProductsSuccess() {
        // Given
        let expectedProducts = [HomeModel(
            createdAt: nil,
            name: "Search Product",
            image: nil,
            price: "20.0",
            description: nil,
            model: nil,
            brand: nil,
            id: "2",
            count: 1
        )]
        mockProductService.shouldReturnError = false
        mockProductService.productsToReturn = expectedProducts

        // When
        let expectation = self.expectation(description: "Search products")
        viewModel.searchProducts(query: "Search") { result in
            switch result {
            case .success:
                XCTAssertEqual(self.viewModel.homeModels, expectedProducts)
            case .failure:
                XCTFail("Expected success but got failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
