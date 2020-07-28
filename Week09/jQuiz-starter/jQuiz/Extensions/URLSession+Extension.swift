//
//  URLSession+Extension.swift
//  jQuiz
//
//  Created by Maitri Mehta on 7/26/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import Foundation

//Generalize the code
protocol NetworkSession {
    @discardableResult
    func getRequest(with urlRequest: URLRequest, completionHandler: @escaping Handler<Data>) -> URLSessionDataTask
}

enum NetworkError: Error {
    case badConnection
    case badData
    case badURL
    case badResponse
}

typealias Handler<T> = (Result<T, NetworkError>) -> Void

extension URLSession: NetworkSession {
    @discardableResult
    func getRequest(with urlRequest: URLRequest, completionHandler: @escaping Handler<Data>) -> URLSessionDataTask {
        let data: URLSessionDataTask = dataTask(with: urlRequest) { (data, response, error) in
            guard  error == nil else {
                completionHandler(.failure(NetworkError.badConnection))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(NetworkError.badResponse))
                return
            }
            
            if self.isResponseOK(response) {
                guard let data = data else {
                    completionHandler(.failure(NetworkError.badData))
                    return
                }
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(NetworkError.badResponse))
            }
        }
        data.resume()
        return data
    }
    
    fileprivate func isResponseOK(_ response: HTTPURLResponse) -> Bool {
        switch response.statusCode {
        case 200...299:
            return true
        default:
            return false
        }
    }
}
