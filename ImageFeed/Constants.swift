//
//  Constants.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 27.04.2024.
//

import UIKit

// API Constants
enum Constants {
    static let AccessKey = "TfJQgGEh9T3FxTGFW-8ihSviLF3FMzgkHaR8_bpAcdE"
    static let SecretKey = "k30QIythuXMmAm6ZqeqxiwHxqsKQsS6FsTi8m1EVj8k"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope = "public+read_user+write_likes"
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
}

// WebView Constants
enum webViewConstants {
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
