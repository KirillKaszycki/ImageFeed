//
//  Photo.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 24.05.2024.
//

import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: URL
    let largeImageURL: URL
    let isLiked: Bool
}
