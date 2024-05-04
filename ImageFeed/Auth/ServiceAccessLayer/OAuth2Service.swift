//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 29.04.2024.
//

import UIKit

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private var lastRequestCode: String?
    private var task: URLSessionTask?
    
    init() {}
    
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
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
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
            guard let request = makeOAuthTokenRequest(code: code) else {
                completion(.failure(NetworkError.urlSessionError))
                return
            }
    
            task = URLSession.shared.data(for: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        let tokenStorage = OAuth2TokenStorage()
                        tokenStorage.token = tokenResponse.accessToken // Save token to UserDefaults
                        completion(.success(tokenResponse.accessToken))
                    } catch {
                        print("Error decoding token response:", error)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("Network error:", error)
                    completion(.failure(error))
                }
            }
            task?.resume()
        }
//    func fetchOAuthToken(code: String, completion: @escaping(Result<String, Error>) -> Void) {
//        assert(Thread.isMainThread)
//        guard lastRequestCode == code else { return }
//        task?.cancel()
//        
//        guard let request = makeOAuthTokenRequest(code: code) else { return }
//        lastRequestCode = code
//        
//        let task = URLSession.shared.data(for: request, completion: completion)
//        
//    }
    
}
