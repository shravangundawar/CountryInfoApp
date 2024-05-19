//
//  CountryListViewModel.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 18/05/24.
//

import Foundation


class CountryListViewModel  {
    var countryListArray: [CountryDataModel] = []
    var errorMessage: String? = nil

    private let countryListUseCase: CountryListUseCase

    init(countryListUseCase: CountryListUseCase) {
        self.countryListUseCase = countryListUseCase
    }

    func fetchCountryList(completion: @escaping (Result<[CountryDataModel], Error>) -> Void) {
        countryListUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countryData):
                    self?.countryListArray = countryData
                    if let data = self?.countryListArray {
                        completion(.success(data))
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }
}
