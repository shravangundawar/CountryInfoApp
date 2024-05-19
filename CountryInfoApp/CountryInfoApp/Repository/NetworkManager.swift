//
//  NetworkManager.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: APIClient {
    private let baseURL = URL(string: AppConstants.APIConstants.baseUrl)!
    private let session = URLSession.shared

//    func request<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
//        let url = baseURL.appendingPathComponent(endpoint)
//        let task = session.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
//                return
//            }
//
//            do {
//                let decodedObject = try JSONDecoder().decode(T.self, from: data)
//                completion(.success(decodedObject))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
    
    func request<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(endpoint)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
