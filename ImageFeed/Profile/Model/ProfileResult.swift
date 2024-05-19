//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 15.05.2024.
//

import UIKit

struct ProfileResult: Codable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
}


