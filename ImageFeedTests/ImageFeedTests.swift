//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Кирилл Кашицкий on 27.05.2024.
//

import Foundation


import XCTest
@testable import ImageFeed

final class ImageFeedTests: XCTestCase {

    func testExample(){
        
    }
    
    func testFetchPhotos() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                               object: nil, queue: .main) { _ in
            expectation.fulfill()
        }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }

}
