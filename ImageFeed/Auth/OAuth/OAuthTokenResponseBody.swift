//
//  OAuthResponseBody.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 29.04.2024.
//

import Foundation

// Sample JSON response
//{
//  "access_token": "091343ce13c8ae780065ecb3b13dc903475dd22cb78a05503c2e0c69c5e98044",
//  "token_type": "bearer",
//  "scope": "public",
//  "created_at": 1588259748
//}

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    // JSON-OAuthTokenResponseBody coincidence verification
    private enum Keys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
