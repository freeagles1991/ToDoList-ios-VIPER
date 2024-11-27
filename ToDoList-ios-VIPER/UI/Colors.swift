//
//  Colors.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

extension UIColor {
    static let dynamicGray = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.lightText: UIColor.darkText
    }
    
    static let dynamicBlack = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.white: UIColor.black
    }
    
    static let dynamicWhite = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.black: UIColor.white
    }
}
