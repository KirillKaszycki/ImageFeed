//
//  Constants.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 27.04.2024.
//

import UIKit

// API Constants
enum Constants {
    static let accessKey = "TfJQgGEh9T3FxTGFW-8ihSviLF3FMzgkHaR8_bpAcdE"
    static let secretKey = "k30QIythuXMmAm6ZqeqxiwHxqsKQsS6FsTi8m1EVj8k"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let profileURL = "https://api.unsplash.com/users/"
}

// WebView Constants
enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
