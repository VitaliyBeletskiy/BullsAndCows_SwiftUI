//
//  Design.swift
//  BullsAndCows
//
//  Created by Vitaliy on 2020-12-15.
//

import SwiftUI

extension Color {
    
    public static let backgroundMain = Color(hex: "#D0ADA7")
    
    public static let backgroundField = Color(hex: "#E8D6CB")
    
    public static let button = Color(hex: "#AD6A6C")
    
    public static let text = Color(hex: "#3F2E46")
    
    public static let picker = Color(hex: "#B58DB6")
    
    public static let rulesBackground = Color(hex: "#E8D6CB")
    
    public init(hex: String) {
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    let r = Double((hexNumber & 0x00ff0000) >> 16) / 255
                    let g = Double((hexNumber & 0x0000ff00) >> 8) / 255
                    let b = Double(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b)
                    return
                }
            }
        }
        self.init(red: 0, green: 0, blue: 0)
    }
    
}

extension UIColor {
    
    public static let background = UIColor(hex: "#E8D6CB")
    
    public static let picker = UIColor(hex: "#B58DB6") // UIColor.systemGroupedBackground
    
    public convenience init(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            var hexColor = String(hex[start...])
            
            if hexColor.count == 6 {
                hexColor += "FF"
            }
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        self.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
}

