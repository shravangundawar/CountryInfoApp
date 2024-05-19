//
//  CountryListUseCase.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation


class CountryListUseCase {
    private let repository: CountryRepository

    init(repository: CountryRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[CountryDataModel], Error>) -> Void) {
        repository.fetchCountryData(completion: completion)
    }
}
