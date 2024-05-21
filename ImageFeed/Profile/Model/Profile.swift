//
//  Profile.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 15.05.2024.
//

import UIKit

struct Profile {
    let username: String?
    let name: String?
    let login_name: String?
    let bio: String?
    
    init(profileResult: ProfileResult) {
        username = profileResult.username
        login_name = "@\(username ?? "")"
        name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")"
        bio = profileResult.bio
    }
}
