//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 15.05.2024.
//

import UIKit

final class ProfileService {
    
    private(set) var profile: Profile? // Private rewriting access with (set)
    private var task: URLSessionTask?
    private var lastToken: String?
    private let profileImageService = ProfileImageService.shared
    
    static let shared = ProfileService() // Do the singletone pattern
    
    private init() {} // Do the singletone pattern
    
    private func createProfileRequest(token: String) -> URLRequest {
        let baseURL = Constants.defaultBaseURL
        var request = URLRequest(url: URL(string: "/me",
                                          relativeTo: baseURL)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        lastToken = token
        
        let request = createProfileRequest(token: token)
        let task = URLSession.shared.data(for: request) { [self] (result: Result<ProfileResult, Error>) in
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self.profile = profile
                
                guard let userName = profile.username else { return }
                profileImageService.fetchProfileImageURL(username: userName) { _ in }
                
                // Successfully parsed via completion
                completion(.success(profile))
                print("Successfully parsed via completion")
            case .failure(let error):
                completion(.failure(error))
                print("Parsing error via completion")
            }
            self.lastToken = nil
            self.task = nil
        }
        task.resume()
    }
}
