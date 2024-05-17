//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 17.05.2024.
//

import UIKit

final class ProfileImageService {
    
    private let token = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    static let shared = ProfileImageService()
    private init() {}
    
    private func createProfileImageRequest(username: String) -> URLRequest? {
        guard let profileURL = URL(string: Constants.profileURL + username) else { return nil }
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // REDO
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = createProfileImageRequest(username: username) else { return }
        
        let task = URLSession.shared.data(for: request) { [weak self] (result: Result<Data, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    // Assuming ProfileResult conforms to Decodable
                    let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                    if let avatarURL = profileResult.profile_image?.small {
                        self.avatarURL = avatarURL
                        completion(.success(avatarURL))
                        print("Image parsing succeeded")
                    } else {
                        print("Parsing image Error")
                        completion(.failure(NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to parse profile image URL"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
