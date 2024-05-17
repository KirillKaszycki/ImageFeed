//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 15.05.2024.
//

import UIKit

struct ProfileResult: Codable {
    let username: String?
    let first_name: String?
    let last_name: String?
    let bio: String?
    let profile_image: ProfileImage?
}


