//
//  ProfileViewSpy.swift
//  ProfileTests
//
//  Created by Кирилл Кашицкий on 21.06.2024.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfileViewPeresenterProtocol)?
    var updateAvatar = 0
    var updateURL: URL?
    var updateProfileDataCalled = 0
    var updateProfileData: Profile?
    var profileImageServiceObserver: NSObjectProtocol?
    
    func updateAvatar(url: URL) {
        updateAvatar += 1
        updateURL = url
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        updateProfileDataCalled += 1
        updateProfileData = profile
    }
}

