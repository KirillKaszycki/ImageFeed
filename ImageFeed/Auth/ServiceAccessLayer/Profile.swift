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
    let loginName: String?
    let bio: String?
    
    init(profileResult: ProfilResult) {
        username = profileResult.login
        loginName = "@" + (username ?? "")
        name = "\(profileResult.first_name ?? "") \(profileResult.last_name ?? "")"
        bio = profileResult.bio
    }
}
