//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 06.06.2024.
//

import UIKit
import WebKit

final class ProfileLogoutService {
    private let imagesListService = ImagesListService.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    static let shared = ProfileLogoutService()
    private init() {}
    
    func logout() {
        cleanCookies()
        cleanProfileData()
        cleanTokenData()
        switchToSplashVC()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(
                        ofTypes: record.dataTypes,
                        for: [record],
                        completionHandler: {})
            }
        }
    }
    
    func switchToSplashVC() {
        guard let window = UIApplication.shared.windows.first else { return }
        let vc = SplashViewController()
        window.rootViewController = vc
    }
}

// MARK: - Clean profile data
extension ProfileLogoutService {
    private func cleanProfileData() {
        imagesListService.cleanImagesList()
        profileService.cleanProfileData()
        profileImageService.cleanProfileImageData()
    }
    
    private func cleanTokenData() {
        let oAuth2TokenStorage = OAuth2TokenStorage()
        oAuth2TokenStorage.cleanTokenData()
    }
}
