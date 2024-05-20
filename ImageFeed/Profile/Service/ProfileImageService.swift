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
        guard let profileURL = URL(string: ProfileConstants.ProfileImageRequest + username) else { return nil }
        var request = URLRequest(url: profileURL)
        request.httpMethod = "GET"
        
        guard let profileToken = token.token else { return nil }
        request.setValue("Bearer \(profileToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        print("SMTH")
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = createProfileImageRequest(username: username) else { return }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                guard let profileImageURL = image.profileImage?.large else {
                    completion(.failure(NetworkError.imageURLParsingError))
                    print("Image URL parsing error")
                    return
                }
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                print("Image URL successfully parsed via completion  \n\(profileImageURL) \n")
                
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
