//
//  HomeViewTests.swift
//  E-MarketTests
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import XCTest
@testable import E_Market

class HomeViewTests: XCTestCase {

    var homeView: HomeView!

    override func setUp() {
        super.setUp()
        homeView = HomeView(frame: .zero)
    }

    override func tearDown() {
        homeView = nil
        super.tearDown()
    }

    func testSubviewsInitialization() {
        // Assert that the headerView is added to the view
        XCTAssertNotNil(homeView.headerView.superview)
        // Assert that the searchBar is added to the view
        XCTAssertNotNil(homeView.searchBar.superview)
        // Assert that the horizontalStackView is added to the view
        XCTAssertNotNil(homeView.horizontalStackView.superview)
        // Assert that the collectionView is added to the view
        XCTAssertNotNil(homeView.collectionView.superview)
    }
    
    func testSubviewProperties() {
        // Assert that the filterButton's title is correct
        XCTAssertEqual(homeView.filterButton.title(for: .normal), "Select Filter")
        // Assert that the filterButton's backgroundColor is lightGray
        XCTAssertEqual(homeView.filterButton.backgroundColor, UIColor.lightGray)
        // Assert that the searchBar's placeholder is correct
        XCTAssertEqual(homeView.searchBar.placeholder, "Search")
    }

    func testConstraints() {
        // Access the constraints to test them
        let headerViewConstraints = homeView.constraints.filter {
            $0.firstItem === homeView.headerView
        }
        
        // Ensure that headerView has constraints
        XCTAssertFalse(headerViewConstraints.isEmpty)
        
        // Similarly, you can check constraints for other subviews
        // Ensure searchBar has constraints
        let searchBarConstraints = homeView.constraints.filter {
            $0.firstItem === homeView.searchBar
        }
        XCTAssertFalse(searchBarConstraints.isEmpty)
        
        // Ensure horizontalStackView has constraints
        let horizontalStackViewConstraints = homeView.constraints.filter {
            $0.firstItem === homeView.horizontalStackView
        }
        XCTAssertFalse(horizontalStackViewConstraints.isEmpty)
        
        // Ensure collectionView has constraints
        let collectionViewConstraints = homeView.constraints.filter {
            $0.firstItem === homeView.collectionView
        }
        XCTAssertFalse(collectionViewConstraints.isEmpty)
    }

    func testFilterButtonTap() {
        // Set up expectation if needed (for async tasks)
        let expectation = self.expectation(description: "Filter button tap")
        
        // Ensure the button has the correct title
        XCTAssertEqual(homeView.filterButton.title(for: .normal), "Select Filter")
        
        // Simulate button tap
        homeView.filterButton.sendActions(for: .touchUpInside)
        
        // Add assertions to check expected behavior if necessary
        // For example, if you expect some state change or method call:
        // XCTAssert(someCondition)
        
        // Fulfill the expectation if it is used
        expectation.fulfill()
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
