//
//  OrderBookViewController.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class OrderBookViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: IOrderBookPresenter!

    var didScrollToMiddle = false

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
        title = "Стакан"

        let actionButton = UIButton(type: .custom)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        let runImage = UIImage(systemName: "play.circle.fill", withConfiguration: imageConfig)?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        actionButton.setImage(runImage, for: .normal)
        let stopImage = UIImage(systemName: "stop.circle.fill", withConfiguration: imageConfig)?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        actionButton.setImage(stopImage, for: .selected)
        actionButton.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: actionButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc func actionButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            let controller = UIAlertController(confirm: "Вы уверены, что хотите остановить робота?", action: "Остановить") { [weak self] in
                self?.toggleActionButton(sender)
            }
            present(controller, animated: true)
        } else {
            toggleActionButton(sender)
        }
    }

    func toggleActionButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isRunning = sender.isSelected
        presenter.setState(running: isRunning)
        navigationItem.leftBarButtonItem = isRunning ? UIBarButtonItem() : nil
    }

    func scrollToMiddle() {
        let section: OrderBookPresenter.Section = .bid
        guard let index = presenter.sections.firstIndex(of: section),
            !presenter.rows(in: section).isEmpty
        else { return }
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        didScrollToMiddle = true
    }

    func rowModel(at indexPath: IndexPath) -> OrderBookPresenter.RowModel {
        let section = presenter.sections[indexPath.section]
        let row = presenter.rows(in: section)[indexPath.row]
        return row
    }
}

extension OrderBookViewController: IOrderBookView {

    func reloadData() {
        collectionView.reloadData()

        if !didScrollToMiddle {
            scrollToMiddle()
        }
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
        let row = rowModel(at: indexPath)
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
        let row = rowModel(at: indexPath)
        let normalHeight = OrderBookCell.height
        let height: CGFloat
        switch row.orderType {
        case .stopLoss, .takeProfit: height = normalHeight * 0.75
        default: height = normalHeight
        }
        return CGSize(width: collectionView.frame.width, height: height)
    }
}

