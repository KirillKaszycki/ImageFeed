//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 13.06.2024.
//

import UIKit

final class ProfileViewPresenter: ProfileViewPeresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        updateProfileDetails()
        profileImageServiceObserverSetting()
        updateAvatar()
    }
    
    // Avatar update
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(url: url)
    }
    
    // Profile date update
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }
    
    func profileImageServiceObserverSetting() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotofication,
            object: nil,
            queue: .main
        ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
        }
        updateAvatar()
    }
    
    func profileImageServiceRemoveObserver() {
        if let obderver = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(obderver)
        }
    }
    
    // LogUot button Logics
    func logout() {
        let profileLogout = ProfileLogoutService.shared
        profileLogout.logout()
    }
}
