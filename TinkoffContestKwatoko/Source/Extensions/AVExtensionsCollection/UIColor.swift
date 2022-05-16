//
//  UIColor.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import UIKit

extension UIColor {

    static var random: UIColor {
        return UIColor(red: CGFloat(arc4random() % 255) / 255.0,
                       green: CGFloat(arc4random() % 255) / 255.0,
                       blue: CGFloat(arc4random() % 255) / 255.0,
                       alpha: 1)
    }

    convenience init?(hex: String) {
        var hexColor = hex
        if hex.hasPrefix("#") {
            hexColor.removeFirst()
        }
        if hexColor.count == 6 {
            hexColor += "ff"
        }
        guard hexColor.count == 8 else { return nil }

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }

        let r, g, b, a: CGFloat
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
