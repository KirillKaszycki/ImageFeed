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
        let baseURL = APIConstants.defaultBaseURL
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
        let task = URLSession.shared.objectTask(for: request) { [self] (result: Result<ProfileResult, Error>) in
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self.profile = profile
                
                // Successfully parsed via completion
                completion(.success(profile))
                
                
                print("Profile data successfully parsed via completion \n\(profile) \n")
            case .failure(let error):
                print("[fetchProfile]: \(error) - \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.lastToken = nil
            self.task = nil
        }
        task.resume()
    }
}
