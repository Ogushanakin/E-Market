//
//  HomeViewControllerTests.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class HomeViewControllerTests: XCTestCase {

    var viewController: HomeViewController!
    var mockProductService: MockProductService!

    override func setUp() {
        super.setUp()
        mockProductService = MockProductService()
        viewController = HomeViewController()
        viewController.homeViewModel = HomeViewModel(productService: mockProductService)
        _ = viewController.view
    }

    override func tearDown() {
        viewController = nil
        mockProductService = nil
        super.tearDown()
    }

    func testFetchMoreDataSuccess() {
        let expectedProducts = [Product(
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

        let expectation = self.expectation(description: "Fetch more products")
        viewController.triggerFetchMoreDataForTesting {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)

        XCTAssertEqual(viewController.homeView.collectionView.numberOfItems(inSection: 0), expectedProducts.count)
    }
}
