//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 29.04.2024.
//

import UIKit

final class OAuth2TokenStorage {
    static var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "OAuth2Token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OAuth2Token")
        }
    }
}
