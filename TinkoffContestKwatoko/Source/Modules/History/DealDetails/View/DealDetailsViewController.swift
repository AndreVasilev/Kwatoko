//
//  DealDetailsViewController.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class DealDetailsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var presenter: IDealDetailsPresenter!

    init(presenter: IDealDetailsPresenter) {
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

private extension DealDetailsViewController {

    func configure() {

    }
}

extension DealDetailsViewController: IDealDetailsView {

}

// MARK: UITableViewDataSource

extension DealDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .info: return dequeueInfoCell(tableView, forRowAt: indexPath)
        case .open, .close: return dequeueBookOrderCell(tableView, forRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.titleForSection(section)
    }
}

// MARK: Dequeue

private extension DealDetailsViewController {

    func dequeueInfoCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DealDetailsInfoCell.reuseIdentifier, for: indexPath)
        (cell as? DealDetailsInfoCell)?.configure(deal: presenter.deal)
        return cell
    }

    func dequeueBookOrderCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DealDetailsBookOrderCell.reuseIdentifier, for: indexPath)
        if let model = presenter.bookOrderModel(at: indexPath) {
            (cell as? DealDetailsBookOrderCell)?.configure(model: model)
        }
        return cell
    }
}
