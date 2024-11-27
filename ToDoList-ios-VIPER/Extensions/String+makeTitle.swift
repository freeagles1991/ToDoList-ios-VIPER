//
//  String+makeTitle.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 27.11.2024.
//

import Foundation

extension String {
    func makeShortTitle() -> String {
        let words = self.split(separator: " ")
        guard words.count > 2 else {
            return self
        }
        let threeWords = words.prefix(3).joined(separator: " ")
        if threeWords.count > 12 {
            return words.prefix(2).joined(separator: " ")
        }
        return threeWords
    }
}
