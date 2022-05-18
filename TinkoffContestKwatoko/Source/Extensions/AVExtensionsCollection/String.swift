//
//  String.swift
//
//  Created by Andrey Vasilev on 20.02.2020.
//  Copyright © 2020 Andrey Vasilev. All rights reserved.
//

import UIKit

extension String {

    var nbsp: String { "\u{00a0}" }

    func calculateHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: [.font: font],
                                            context: nil)
        return boundingBox.height
    }

    var toInt: Int? { Int(self) }
    var toInt64: Int64? { Int64(self) }
    var toDouble: Double? { Double(self) }
    var toDecimal: Decimal? { Decimal(string: self) }
}
