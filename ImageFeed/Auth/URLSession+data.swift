//
//  URLSession_data.swift
//  ImageFeed
//
//  Created by Кирилл Кашицкий on 29.04.2024.
//

import Foundation

enum NetworkError: Error {
    case urlRequestError(Error)
    case urlSessionError
    case imageError
    case decodingError
    case httpStatusCode(Int, String)
    case imageURLParsingError
    case invalidRequest
}


extension URLSession {
    // This shall be used for fetching pforile data and images list
    func objectTask <T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(T.self, from: data)
                        fulfillCompletionOnTheMainThread(.success(result))
                    } catch {
                        fulfillCompletionOnTheMainThread(.failure(NetworkError.decodingError))
                        print("Ошибка декодирования: \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                } else {
                    let errorMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode, errorMessage)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
    
    // This shall be used for like POST/DELETE
    func objectTaskData (for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async { completion(result) } }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let status = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= status {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    let error = HTTPURLResponse.localizedString(forStatusCode: status)
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(status, error)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
        return task
    }
}
