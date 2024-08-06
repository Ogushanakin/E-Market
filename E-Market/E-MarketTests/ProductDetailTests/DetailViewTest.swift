//
//  DetailViewTest.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class DetailViewTests: XCTestCase {

    var detailView: DetailView!
    var mockViewModel: MockDetailViewModel!

    override func setUpWithError() throws {
        detailView = DetailView()
        mockViewModel = MockDetailViewModel(product: Product(name: "Test Product", image: nil, price: "100", description: "Test Description"), isInCart: true)
    }

    override func tearDownWithError() throws {
        detailView = nil
        mockViewModel = nil
    }

    func testConfigureWithViewModel() throws {
        detailView.configure(with: mockViewModel)
        
        XCTAssertEqual(detailView.titleLabel.text, "Test Product")
        XCTAssertEqual(detailView.descriptionLabel.text, "Test Description")
        XCTAssertEqual(detailView.priceValueLabel.text, "100₺")
        XCTAssertEqual(detailView.addToCartButton.title(for: .normal), "Remove from Cart")
    }
}
