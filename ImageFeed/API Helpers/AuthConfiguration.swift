//
//  Constants.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 27.04.2024.
//

import UIKit

// API Constants
enum APIConstants {
    static let accessKey = "TfJQgGEh9T3FxTGFW-8ihSviLF3FMzgkHaR8_bpAcdE"
    static let secretKey = "k30QIythuXMmAm6ZqeqxiwHxqsKQsS6FsTi8m1EVj8k"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: APIConstants.accessKey,
            secretKey: APIConstants.secretKey,
            redirectURI: APIConstants.redirectURI,
            accessScope: APIConstants.accessScope,
            defaultBaseURL: APIConstants.defaultBaseURL,
            authURLString: APIConstants.unsplashAuthorizeURLString)
    }
}

