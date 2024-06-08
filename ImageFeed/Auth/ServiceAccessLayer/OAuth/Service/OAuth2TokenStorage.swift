//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 29.04.2024.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "OAuth2Token")
        }
        set {
            guard let newValue = newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: "OAuth2Token")
        }
    }
    
    func cleanTokenData() {
        KeychainWrapper.standard.removeObject(forKey: "OAuth2Token")
    }
}
