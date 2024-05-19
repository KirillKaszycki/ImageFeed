//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 29.04.2024.
//

import UIKit

fileprivate enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private var lastRequestCode: String?
    private var task: URLSessionTask?
    
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            return nil
        }
        
        guard let url = URL(string: "/oauth/token",
                            relativeTo: baseURL) else {
            return nil
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: APIConstants.accessKey),
            URLQueryItem(name: "client_secret", value: APIConstants.secretKey),
            URLQueryItem(name: "redirect_uri", value: APIConstants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let finalURL = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping(Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastRequestCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastRequestCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastRequestCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.urlSessionError))
            return
        }

        let task = URLSession.shared.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let res):
                let authToken = res.accessToken
                let tokenStorage = OAuth2TokenStorage()
                tokenStorage.token = authToken
                completion(.success(authToken))
                print("Authorizing successfull")
            case .failure(let error):
                print("[OAurh2Service]: \(error) - \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
            self.lastRequestCode = nil
        }
        task.resume()
    }
}
