//
//  UICollectionView+Cells.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import UIKit

extension UICollectionView {

    func register<T: UICollectionViewCell>(cellClass: T.Type?) {
        register(cellClass, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func registerNib<T: UICollectionViewCell>(cellClass: T.Type?) {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(headerClass: T.Type?) {
        register(supplementaryClass: headerClass, ofKind: UICollectionView.elementKindSectionHeader)
    }

    func register<T: UICollectionReusableView>(footerClass: T.Type?) {
        register(supplementaryClass: footerClass, ofKind: UICollectionView.elementKindSectionFooter)
    }

    func registerNib<T: UICollectionReusableView>(cellClass: T.Type?, forSupplementaryViewOfKind kind: String) {
        register(T.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }

    private func register<T: UICollectionReusableView>(supplementaryClass: T.Type?, ofKind kind: String) {
        register(supplementaryClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
}
