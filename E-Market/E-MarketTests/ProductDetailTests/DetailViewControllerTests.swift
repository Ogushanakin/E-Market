//
//  DetailViewControllerTest.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class DetailViewControllerTests: XCTestCase {

    var viewController: DetailViewController!
    var mockViewModel: MockDetailViewModel!
    var mockDelegate: MockDetailViewControllerDelegate!

    override func setUp() {
        super.setUp()
        let product = Product(name: "Test Product", image: nil, price: "100", description: "Test Description", id: "1", count: 1)
        mockViewModel = MockDetailViewModel(product: product, isInCart: false)
        mockDelegate = MockDetailViewControllerDelegate()
        viewController = DetailViewController(viewModel: mockViewModel)
        viewController.delegate = mockDelegate
        _ = viewController.view
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testAddToCartButtonTitleWhenInCart() {
        mockViewModel.isInCart = true
        viewController.updateButtonTitle()
        XCTAssertEqual(viewController.detailView.addToCartButton.title(for: .normal), "Remove from Cart")
    }

    func testAddToCartButtonTitleWhenNotInCart() {
        mockViewModel.isInCart = false
        viewController.updateButtonTitle()
        XCTAssertEqual(viewController.detailView.addToCartButton.title(for: .normal), "Add to Cart")
    }

    func testAddToCartButtonTapped() {
        viewController.addToCartButtonTapped()
        XCTAssertTrue(mockViewModel.isInCart)
        XCTAssertTrue(mockDelegate.didUpdateCartCalled)
    }

    func testCartDidUpdate() {
        mockViewModel.isInCart = true
        viewController.cartDidUpdate()
        XCTAssertEqual(viewController.detailView.addToCartButton.title(for: .normal), "Remove from Cart")
    }
}

class MockDetailViewModel: DetailViewModel {
    var mockIsInCart: Bool

    override var isInCart: Bool {
        get {
            return mockIsInCart
        }
        set {
            mockIsInCart = newValue
        }
    }

    override init(product: Product, isInCart: Bool) {
        self.mockIsInCart = isInCart
        super.init(product: product, isInCart: isInCart)
    }

    override func toggleCartStatus() {
        super.toggleCartStatus()
        // Additional mocking behavior if needed
    }
}

class MockDetailViewControllerDelegate: DetailViewControllerDelegate {
    var didUpdateCartCalled = false
    
    func didUpdateCart() {
        didUpdateCartCalled = true
    }
}
