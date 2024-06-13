//
//  WebViewPresenterSpy.swift
//  WebViewTests
//
//  Created by Кирилл Кашицкий on 13.06.2024.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newvalue: Double) { }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
