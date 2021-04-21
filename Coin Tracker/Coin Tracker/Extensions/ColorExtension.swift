//
//  ColorExtension.swift
//  Coin Tracker
//
//  Created by Jesper Bertelsen on 19/04/2021.
//

import SwiftUI

extension Color {
    
    static let base = Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
    static let grayish = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    static let greenish = Color(#colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1))
    static let darkShadow = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    
    init(hex: String) {
        self.init(UIColor.init(hex: hex))
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        var inputString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if inputString.hasPrefix("#") {
            inputString.remove(at: inputString.startIndex)
        }
        var rgbValue: UInt64 = 0
        
        Scanner(string: inputString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat((rgbValue & 0x0000FF)) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
