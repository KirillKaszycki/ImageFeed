//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Кирилл Кашицкий on 28.03.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText("log")
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("pass")
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        sleep(2)
        tablesQuery.element.swipeUp()
        
        let cellLike = tablesQuery.cells.firstMatch
        let likeButton = cellLike.buttons["LikeButton"]
        likeButton.tap()
        sleep(2)
        likeButton.tap()
        sleep(2)
        cellLike.tap()
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(3)
       
        XCTAssertTrue(app.staticTexts["Kirill Kashitskii"].exists)
        XCTAssertTrue(app.staticTexts["@kirill_de_franco"].exists)
        sleep(3)
        app.buttons["logout button"].tap()
        sleep(3)
        let logoutAlert = app.alerts["Пока пока!"]
        XCTAssertTrue(logoutAlert.exists, "Logout alert does not exist")
        logoutAlert.buttons["Да"].tap()
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    }
}
