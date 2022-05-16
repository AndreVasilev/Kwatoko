//
//  DateFormatter.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

extension DateFormatter {

    convenience init(_ dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}
