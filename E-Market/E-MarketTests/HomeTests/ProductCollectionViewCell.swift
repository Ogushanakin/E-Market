//
//  ProductCollectionViewCell.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class ProductCollectionViewCellTests: XCTestCase {

    var cell: ProductCollectionViewCell!
    var mockDelegate: MockProductCollectionViewCellDelegate!

    override func setUp() {
        super.setUp()
        cell = ProductCollectionViewCell(frame: .zero)
        mockDelegate = MockProductCollectionViewCellDelegate()
        cell.delegate = mockDelegate
    }

    override func tearDown() {
        cell = nil
        mockDelegate = nil
        super.tearDown()
    }

    func testConfigureWithModel() {
        // Given
        let model = Product(
            createdAt: nil,
            name: "Test Product",
            image: "https://example.com/image.jpg",
            price: "10.0",
            description: nil,
            model: nil,
            brand: nil,
            id: "1",
            count: 1
        )
        
        // When
        cell.configure(with: model)
        
        // Then
        XCTAssertEqual(cell.nameLabel.text, "Test Product")
        XCTAssertEqual(cell.priceLabel.text, "$10.0")
        XCTAssertNotNil(cell.productImageView.image)
        XCTAssertEqual(cell.addToCartButton.title(for: .normal), "Add to Cart")
        XCTAssertEqual(cell.favoriteButton.imageView?.image, UIImage(named: "Star 2"))
    }

    func testAddToCartButtonTapped() {
        // Given
        cell.configure(with: Product(name: "Test Product", image: nil, price: "10.0", id: "1"))
        
        // When
        cell.addToCartButton.sendActions(for: .touchUpInside)
        
        // Then
        XCTAssertTrue(mockDelegate.didCallAddToCart)
    }

    func testFavoriteButtonTapped() {
        // Given
        cell.configure(with: Product(name: "Test Product", image: nil, price: "10.0", id: "1"))
        
        // When
        cell.favoriteButton.sendActions(for: .touchUpInside)
        
        // Then
        XCTAssertTrue(mockDelegate.didCallFavorite)
    }
}

// Mock Delegate
class MockProductCollectionViewCellDelegate: ProductCollectionViewCellDelegate {
    
    var didCallAddToCart = false
    var didCallFavorite = false

    func didSelectAddToCart(cell: ProductCollectionViewCell) {
        didCallAddToCart = true
    }
    
    func didSelectFavorite(cell: ProductCollectionViewCell) {
        didCallFavorite = true
    }
}
