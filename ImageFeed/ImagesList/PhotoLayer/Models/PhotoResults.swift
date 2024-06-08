//
//  PhotoResults.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 24.05.2024.
//

import UIKit

struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}

struct PhotoResults: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
    let likes: Int
}

typealias PhotoResultList = [PhotoResults]
