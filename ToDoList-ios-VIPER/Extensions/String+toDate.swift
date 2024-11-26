//
//  String+toDate.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 26.11.2024.
//

import Foundation

extension String {
    func toDate(format: String = "MM/dd/yy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        if let parsedDate = dateFormatter.date(from: self) {
            return parsedDate
        } else {
            let currentDateString = dateFormatter.string(from: Date())
            return dateFormatter.date(from: currentDateString) ?? Date()
        }
    }
}

