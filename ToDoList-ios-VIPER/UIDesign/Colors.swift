//
//  Colors.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
    
    static let yaGray = UIColor(hexString: "#272729")
    
    static let dynamicGray = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.lightText: UIColor.darkText
    }
    
    static let dynamicBlack = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.white: UIColor.black
    }
    
    static let dynamicWhite = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.black: UIColor.white
    }
    
    static let dynamicYellow = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.systemYellow: UIColor.systemOrange
    }
    
    static let dynamicLightGray = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.yaGray : UIColor.systemGray5
    }
}
