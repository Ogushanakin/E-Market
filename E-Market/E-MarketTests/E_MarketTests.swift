//
//  E_MarketTests.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 5.08.2024.
//

import XCTest
@testable import E_Market

final class E_MarketTests: XCTestCase {

    override func setUpWithError() throws {
        // Setup kodları buraya
    }

    override func tearDownWithError() throws {
        // Teardown kodları buraya
    }

    func testHomeModelInitialization() throws {
        // Given
        let model = Product(
            createdAt: "2024-01-01",
            name: "Test Product",
            image: "image_url",
            price: "10.0",
            description: "Product description",
            model: "Model X",
            brand: "Brand Y",
            id: "1",
            count: 1
        )
        
        // Then
        XCTAssertNotNil(model)
        XCTAssertEqual(model.name, "Test Product")
        XCTAssertEqual(model.price, "10.0")
        XCTAssertEqual(model.id, "1")
    }

    func testNetworkManagerPerformance() throws {
        // Performans testi örneği
        self.measure {
            // Ölçmek istediğiniz kod
            let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products")!
            let expectation = self.expectation(description: "Network request")
            
            NetworkManager.shared.fetch(url: url, responseType: [Product].self) { result in
                switch result {
                case .success:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Network request failed: \(error.localizedDescription)")
                }
            }
            
            waitForExpectations(timeout: 5.0, handler: nil)
        }
    }
}
