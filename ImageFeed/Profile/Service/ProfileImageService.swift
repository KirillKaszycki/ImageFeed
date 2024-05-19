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
    static let didChangeNotofication = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    private init() {}
    
    private func createProfileImageRequest(username: String) -> URLRequest? {
        guard let profileURL = URL(string: Constants.profileURL + username) else { return nil }
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = createProfileImageRequest(username: username) else { return }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                guard let profileImageURL = image.profileImage?.small else {
                    completion(.failure(NetworkError.imageURLParsingError))
                    print("Image URL parsing error")
                    return
                }
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                print("Image URL successfully parsed")
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotofication,
                    object: self,
                    userInfo: ["URL": profileImageURL])
                
            case .failure(let error):
                print("[fetchProfileImageURL]: \(error) - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
