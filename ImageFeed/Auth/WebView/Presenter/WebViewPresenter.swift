//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 13.06.2024.
//

import UIKit

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: APIConstants.accessKey),
            URLQueryItem(name: "redirect_uri", value: APIConstants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: APIConstants.accessScope)
        ]
        
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newvalue: Double) {
        let newProgressValue = Float(newvalue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" } ) {
            return codeItem.value
        } else {
            return nil
        }
    }
}
