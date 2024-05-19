//
//  CountryListUseCase.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation
import UIKit

class CountryListUseCase {
    private let repository: CountryRepository

    init(repository: CountryRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[CountryDataModel], Error>) -> Void) {
        repository.fetchCountryData(completion: completion)
    }
    
    func executeFetchImage(with url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        repository.fetchImage(from: url, completion: completion)
    }

}
