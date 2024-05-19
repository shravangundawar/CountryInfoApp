//
//  CountryListViewModel.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 18/05/24.
//

import Foundation
import UIKit

// Define the enum for filter options
enum PopulationFilter {
    case lessThan1Million
    case lessThan5Million
    case lessThan10Million
    case lessThan20Million
    case removeFilter
    
    var threshold: Int {
        switch self {
        case .lessThan1Million:
            return 1_000_000
        case .lessThan5Million:
            return 5_000_000
        case .lessThan10Million:
            return 10_000_000
        case .lessThan20Million:
            return 20_000_000
        case .removeFilter:
            return 0
        }
    }
}


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
    
    func searchCountryByName(searchText: String) -> [CountryDataModel] {
        let tempArray = countryListArray
        return tempArray.filter { $0.name.lowercased().hasPrefix(searchText.lowercased())}
        //FutureReference: Alternate option below to apply filter using containing letters
        //contains(searchText.lowercased())
    }
    
    func filterCountries(by filter: PopulationFilter) -> [CountryDataModel] {
        if filter == .removeFilter {
            return countryListArray
        }
        let tempArray = countryListArray
        return tempArray.filter { $0.population ?? 0 < filter.threshold }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        countryListUseCase.executeFetchImage(with: url) { result in
             switch result {
             case .success(let image):
                 completion(image)
             case .failure:
                 completion(nil)
             }
         }
     }
}
