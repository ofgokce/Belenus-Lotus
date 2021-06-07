//
//  RestfulManager.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 20.05.2021.
//

import Foundation

class RestfulManager {
    static let shared = RestfulManager()
    private init() {}
    
    func request<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("\(request.httpMethod ?? "Some") Request: \(request.url?.absoluteString ?? "no url")")
            print("Response: \(response.debugDescription)")
            print(data ?? "data error")
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error!))
            }
        }.resume()
    }
}
