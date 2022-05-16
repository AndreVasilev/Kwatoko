//
//  Date.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

extension Date {

    static var random: Date {
        let base = TimeInterval(1500000000)
        let timeIntervalSince1970 = Date().timeIntervalSince1970
        let m = 100000.0
        let d = UInt32((timeIntervalSince1970 - base) / m)
        let timeInterval = base + TimeInterval(arc4random()%d) * m
        return Date.init(timeIntervalSince1970: TimeInterval(timeInterval))
    }
}
