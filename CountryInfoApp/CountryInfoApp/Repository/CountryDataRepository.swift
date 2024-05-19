//
//  CountryDataRepository.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation
import UIKit

protocol CountryRepository {
    func fetchCountryData(completion: @escaping (Result<[CountryDataModel], Error>) -> Void)
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class CountryDataRepository: CountryRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchCountryData(completion: @escaping (Result<[CountryDataModel], Error>) -> Void) {
        apiClient.request(endpoint: AppConstants.APIConstants.countryListEndpoint) { (result: Result<[CountryDataModel], Error>) in
            switch result {
            case .success(let countryData):
                completion(.success(countryData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        apiClient.fetchImage(from: url, completion: completion)
    }
}
