//
//  CountryListUseCase.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation
import UIKit

class CountryListUseCase {
    //MARK: Properties
    private let repository: CountryRepository

    init(repository: CountryRepository) {
        self.repository = repository
    }

    //MARK: Methods
    func execute(completion: @escaping (Result<[CountryDataModel], Error>) -> Void) {
        if NetworkReachability.shared.isNetworkAvailable {
            repository.fetchCountryData(completion: completion)
        } else {
            NotificationCenter.default.addObserver(forName: .networkAvailable, object: nil, queue: .main) {[weak self] _ in
                self?.repository.fetchCountryData(completion: completion)
                NotificationCenter.default.removeObserver(self!, name: .networkAvailable, object: nil)
            }
        }
    }
    
    func executeFetchImage(with url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        repository.fetchImage(from: url, completion: completion)
    }

}
