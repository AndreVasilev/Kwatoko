//
//  CGSize.swift
//
//  Created by Andrey Vasilev on 27.12.2020.
//

import UIKit

extension CGSize {

    func with(width: CGFloat) -> CGSize {
        var size = self
        size.width = width
        return size
    }

    func with(height: CGFloat) -> CGSize {
        var size = self
        size.height = height
        return size
    }
}
