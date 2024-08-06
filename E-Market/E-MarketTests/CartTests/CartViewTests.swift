//
//  CartViewTests.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class CartViewTests: XCTestCase {

    var cartView: CartView!
    var mockCartManager: MockCartManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockCartManager = MockCartManager()
        cartView = CartView()
    }

    override func tearDownWithError() throws {
        cartView = nil
        mockCartManager = nil
        try super.tearDownWithError()
    }

    func testUIComponentsExist() throws {
        XCTAssertNotNil(cartView.headerView)
        XCTAssertNotNil(cartView.tableView)
        XCTAssertNotNil(cartView.totalLabel)
        XCTAssertNotNil(cartView.completeButton)
        XCTAssertNotNil(cartView.emptyView)
    }

    func testInitialEmptyViewIsHidden() throws {
        XCTAssertTrue(cartView.emptyView.isHidden)
    }

    func testUpdateTotalPrice() throws {
        let price = "123.45"
        cartView.updateTotalPrice(with: price)
        XCTAssertEqual(cartView.totalLabel.text, "Total: $123.45")
    }

    func testUpdateCartView_WhenEmpty() throws {
        cartView.updateCartView(isEmpty: true)
        XCTAssertTrue(cartView.tableView.isHidden)
        XCTAssertFalse(cartView.emptyView.isHidden)
    }

    func testUpdateCartView_WhenNotEmpty() throws {
        cartView.updateCartView(isEmpty: false)
        XCTAssertFalse(cartView.tableView.isHidden)
        XCTAssertTrue(cartView.emptyView.isHidden)
    }

    func testCompleteButtonAction() throws {
        cartView.completeButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(mockCartManager.clearCartCalled)
    }
}

class MockCartManager: CartManaging {
    var clearCartCalled = false
    
    func clearCart() {
        clearCartCalled = true
    }
}
