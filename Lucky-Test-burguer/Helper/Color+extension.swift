//
//  Color+extension.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import UIKit

extension UIColor {
    
    //MARK: CUSTOM COLOR TEXT
    
    static var grayScale: UIColor {
        return hexStringToUIColor(hex: "#9DB0BD")
    }
    
    static var blackText: UIColor {
        return hexStringToUIColor(hex: "#222D34")
    }
    
    static var grayText: UIColor {
        return hexStringToUIColor(hex: "#718897")
    }
    
    //MARK: Custom with Hex Color
    static var grayColor: UIColor {
        return grayCustomColor()
    }
    
    static var defaultColor: UIColor {
        return hexStringToUIColor(hex: "#ffffff")
    }
    
    private static func grayCustomColor() -> UIColor {
        return hexStringToUIColor(hex: "#F7F9FA")
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
