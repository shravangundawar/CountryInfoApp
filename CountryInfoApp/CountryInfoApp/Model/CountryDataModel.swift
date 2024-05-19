//
//  CountryDataModel.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 18/05/24.
//

import Foundation

struct CountryDataModel: Codable {
    let abbreviation: String
    let capital: String
    let currency: String
    let name: String
    let phone: String
    let population: Int?
    let media: CountryMedia
    let id: Int
}

struct CountryMedia: Codable {
    let flag: String
    let emblem: String
    let orthographic: String
}
