//
//  StringExtension.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation

extension String {
    static func formattedDateWithTimeZone() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        
        // Set the date format
        dateFormatter.dateFormat = "d"
        let day = Int(dateFormatter.string(from: date)) ?? 0
        
        // Get the day suffix
        let daySuffix: String
        switch day {
        case 1, 21, 31:
            daySuffix = "st"
        case 2, 22:
            daySuffix = "nd"
        case 3, 23:
            daySuffix = "rd"
        default:
            daySuffix = "th"
        }
        
        // Set the date format including the day suffix
        dateFormatter.dateFormat = "d'\(daySuffix)' MMM hh:mm a zzz"
        
        // Format the date
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
}
