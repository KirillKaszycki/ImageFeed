//
//  ImagesListTest.swift
//  ImagesListTest
//
//  Created by Кирилл Кашицкий on 21.06.2024.
//

import XCTest
@testable import ImageFeed

class ImagesListPresenterTests: XCTestCase {

    var presenter: ImagesListViewPresenter!
    var spy: ImagesListControllerSpy!
    
    override func setUp() {
        super.setUp()
        spy = ImagesListControllerSpy()
        presenter = ImagesListViewPresenter(view: spy)
    }
    
    override func tearDown() {
        presenter.removeObserver()
        presenter = nil
        spy = nil
        super.tearDown()
    }
    
    func testUpdateTableViewAnimatedCalled() {
        // Given
        let oldCount = 0
        let newPhotos = [
            Photo(
                id: "1",
                size: CGSize(width: 100, height: 100),
                createdAt: "2024-06-21",
                welcomeDescription: "Description",
                thumbImageURL: URL(string: "https://example")!,
                fullImageURL: URL(string: "https://example")!,
                isLiked: false
            ),
            Photo(
                id: "2",
                size: CGSize(width: 200, height: 200),
                createdAt: "2024-06-22",
                welcomeDescription: "Description",
                thumbImageURL: URL(string: "https://example")!,
                fullImageURL: URL(string: "https://example")!,
                isLiked: true
            )
        ]
        
        // When
        presenter.photos = newPhotos
        presenter.updateTableViewAnimated()
        
        // Then
        XCTAssertTrue(spy.isUpdateTableViewAnimatedCalled)
        XCTAssertNotEqual(spy.updateTableViewAnimatedArguments?.oldCount, oldCount)
        XCTAssertNotEqual(spy.updateTableViewAnimatedArguments?.newCount, newPhotos.count)
    }
}
