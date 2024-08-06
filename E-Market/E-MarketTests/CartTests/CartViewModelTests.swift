//
//  CartViewModelTests.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class CartViewModelTests: XCTestCase {
    
    var viewModel: CartViewModel!
    var cartManager: CartManager!
    
    override func setUp() {
        super.setUp()
        cartManager = CartManager.shared
        cartManager.clearCart()
        
        viewModel = CartViewModel()
    }
    
    override func tearDown() {
        cartManager.clearCart()
        viewModel = nil
        super.tearDown()
    }
    
    func testGetTotalPrice_EmptyCart() {
        let totalPrice = viewModel.getTotalPrice()
        XCTAssertEqual(totalPrice, "0.00")
    }
    
    func testGetTotalPrice_WithItems() {
        let product1 = Product(price: "10.00", count: 2)
        let product2 = Product(price: "5.50", count: 1)
        cartManager.addToCart(item: product1)
        cartManager.addToCart(item: product2)
        
        let totalPrice = viewModel.getTotalPrice()
        XCTAssertEqual(totalPrice, "25.50")
    }
    
    func testIncreaseQuantity() {
        let product = Product(price: "10.00", count: 1)
        cartManager.addToCart(item: product)
        viewModel.increaseQuantity(for: product)
        
        let updatedProduct = cartManager.cartItems.first { $0.id == product.id }
        XCTAssertNotNil(updatedProduct)
        XCTAssertEqual(updatedProduct?.count, 2)
    }
    
    func testDecreaseQuantity() {
        let product = Product(price: "10.00", count: 2)
        cartManager.addToCart(item: product)
        viewModel.decreaseQuantity(for: product)
        
        let updatedProduct = cartManager.cartItems.first { $0.id == product.id }
        XCTAssertNotNil(updatedProduct)
        XCTAssertEqual(updatedProduct?.count, 1)
    }
    
    func testDecreaseQuantity_RemovesItemWhenCountIsOne() {
        let product = Product(price: "10.00", count: 1)
        cartManager.addToCart(item: product)
        viewModel.decreaseQuantity(for: product)
        
        let updatedProduct = cartManager.cartItems.first { $0.id == product.id }
        XCTAssertNil(updatedProduct)
    }
    
    func testCartUpdateNotification() {
        let expectation = self.expectation(description: "Cart updated notification")
        
        viewModel.onCartUpdated = {
            expectation.fulfill()
        }
        
        let product = Product(price: "10.00", count: 1)
        cartManager.addToCart(item: product)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
