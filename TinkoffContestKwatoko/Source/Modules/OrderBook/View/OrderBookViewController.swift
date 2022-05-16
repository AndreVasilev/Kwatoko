//
//  OrderBookViewController.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class OrderBookViewController: BaseViewController {

    @IBOutlet var collectionView: UICollectionView!

    var presenter: IOrderBookPresenter!

    init(presenter: IOrderBookPresenter) {
        self.presenter = presenter
        super.init(output: presenter)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension OrderBookViewController {

    func configure() {

    }
}

extension OrderBookViewController: IOrderBookView {

    func reloadData() {
        collectionView.reloadData()
    }
}

extension OrderBookViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = presenter.sections[section]
        return presenter.rows(in: section).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = presenter.sections[indexPath.section]
        let row = presenter.rows(in: section)[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBookCell.reuseIdentifier, for: indexPath)
        (cell as? OrderBookCell)?.configure(model: row)
        return cell
    }
}

extension OrderBookViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
    }
}

extension OrderBookViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: OrderBookCell.height)
    }
}

