//
//  AppConstants.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation

class AppConstants {
    
    class UIConstants {
        static let countryFilterTitle = "Filter by Population"
        static let oneMillion = "< 1M"
        static let fiveMillion = "< 5M"
        static let tenMillion = "< 10M"
        static let twentyMillion = "< 20M"
        static let clear = "Clear Filter"
        static let cancel = "Cancel"
        static let noInternetTitle = "Network Error"
        static let noInternetMessage = "No internet connection"
        static let ok = "OK"
    }
    
    class APIConstants {
        static let baseUrl = "https://api.sampleapis.com/"
        static let countryListEndpoint = "countries/countries"
    }
}
