//
//  CartViewControllerTests.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class CartViewControllerTests: XCTestCase {

    var viewController: CartViewController!
    var mockViewModel: MockCartViewModel!

    override func setUp() {
        super.setUp()
        mockViewModel = MockCartViewModel()
        viewController = CartViewController()
        viewController.viewModel = mockViewModel
        _ = viewController.view
    }

    override func tearDown() {
        viewController = nil
        mockViewModel = nil
        super.tearDown()
    }

    func testViewInitialization() {
        XCTAssertNotNil(viewController.view, "View should be initialized")
        XCTAssertNotNil(viewController.cartView.tableView.delegate, "Table view delegate should be set")
        XCTAssertNotNil(viewController.cartView.tableView.dataSource, "Table view data source should be set")
        XCTAssertEqual(viewController.cartView.tableView.numberOfRows(inSection: 0), 0, "Table view should have 0 rows initially")
    }
    
    func testUIUpdateWhenCartIsEmpty() {
        mockViewModel.cartItems = []
        viewController.updateUI()
        
        XCTAssertTrue(viewController.cartView.tableView.isHidden, "Table view should be hidden when cart is empty")
        XCTAssertEqual(viewController.cartView.totalLabel.text, "0₺", "Total price should be 0₺ when cart is empty")
    }
    
    func testUIUpdateWhenCartHasItems() {
        let product = Product(createdAt: nil, name: "Test Product", image: nil, price: "10", description: nil, model: nil, brand: nil, id: "1", count: 1)
        mockViewModel.cartItems = [product]
        viewController.updateUI()
        
        XCTAssertFalse(viewController.cartView.tableView.isHidden, "Table view should not be hidden when cart has items")
        XCTAssertEqual(viewController.cartView.totalLabel.text, "10₺", "Total price should be 10₺ when cart has one item with price 10₺")
    }
    
    func testTableViewDataSourceMethods() {
        let product = Product(createdAt: nil, name: "Test Product", image: nil, price: "10", description: nil, model: nil, brand: nil, id: "1", count: 1)
        mockViewModel.cartItems = [product]
        viewController.updateUI()
        
        let numberOfRows = viewController.tableView(viewController.cartView.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 1, "Table view should have 1 row when there is 1 product in the cart")
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = viewController.tableView(viewController.cartView.tableView, cellForRowAt: indexPath) as? ProductTableViewCell
        XCTAssertNotNil(cell, "Cell should not be nil")
        XCTAssertEqual(cell?.nameLabel.text, "Test Product", "Cell should display the correct product name")
    }
    
    func testTableViewHeightForRowAt() {
        let height = viewController.tableView(viewController.cartView.tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(height, 100, "Cell height should be 100")
    }
}

class MockCartViewModel: CartViewModel {
    private var _cartItems: [Product] = []
    
    override var cartItems: [Product] {
        get { return _cartItems }
        set { _cartItems = newValue }
    }
    
    override func getTotalPrice() -> String {
        return "\(cartItems.reduce(0) { $0 + (Double($1.price ?? "0") ?? 0) })₺"
    }
}
