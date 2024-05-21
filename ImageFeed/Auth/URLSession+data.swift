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
}
