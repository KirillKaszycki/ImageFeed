//
//  ProfileTests.swift
//  ProfileTests
//
//  Created by Кирилл Кашицкий on 21.06.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    var profilePresenter: ProfileViewPresenter!
    var profileVC: ProfileViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        profileVC = ProfileViewControllerSpy()
        profilePresenter = ProfileViewPresenter(view: profileVC)
    }
    
    override func tearDown() {
        profilePresenter = nil
        profileVC = nil
        super.tearDown()
    }
    
    func testProfileImageServiceRemoveObserver() {
        // Given
        profilePresenter.profileImageServiceObserverSetting()
        
        // When
        profilePresenter.profileImageServiceRemoveObserver()
        
        // Then
        XCTAssertNil(profileVC.profileImageServiceObserver)
    }
}
