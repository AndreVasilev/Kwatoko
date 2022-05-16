//
//  UICollectionView.swift
//  Easy Buying
//
//  Created by Andrey Vasilev on 25.03.2021.
//

import UIKit

extension UICollectionView {

    func deselectItems(animated: Bool = true) {
        indexPathsForSelectedItems?.forEach {
            deselectItem(at: $0, animated: animated)
        }
    }
}
