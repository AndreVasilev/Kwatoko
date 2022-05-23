//
//  AccountViewController.swift
//
//  Created by Andrey Vasilev on 21/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class AccountViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    var presenter: IAccountPresenter!

    var isProcessing: Bool = false {
        didSet {
            isProcessing ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

    init(presenter: IAccountPresenter) {
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

private extension AccountViewController {

    func configure() {
        title = "Счёт"

        activityIndicator.hidesWhenStopped = true
        let item = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = item
    }
}

extension AccountViewController: IAccountView {

    func reloadData() {
        tableView.reloadData()
    }
}

extension AccountViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .info:
            let row = presenter.infoRows[indexPath.row]
            switch row {
            case .info:
                return dequeueInfoCell(tableView, forRowAt: indexPath)
            case .reload, .close:
                return dequeueActionCell(tableView, forRowAt: indexPath)
            }
        case .currencies:
            return dequeueCurrencyCell(tableView, forRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = presenter.sections[section]
        return section.title
    }
}

extension AccountViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        presenter.didSelectRow(at: indexPath)
    }
}

// MARK: Dequeue

private extension AccountViewController {

    func dequeueInfoCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountInfoCell.reuseIdentifier, for: indexPath)
        (cell as? AccountInfoCell)?.configure(model: presenter.info) { [weak self] in
            self?.presenter.updateAccount(name: $0)
        }
        return cell
    }

    func dequeueActionCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RobotsActionCell.reuseIdentifier, for: indexPath)
        if let action = presenter.action(at: indexPath) {
            (cell as? RobotsActionCell)?.configure(action: action)
        }
        return cell
    }
    
    func dequeueCurrencyCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountCurrencyCell.reuseIdentifier, for: indexPath)
        if let model = presenter.position(at: indexPath) {
            (cell as? AccountCurrencyCell)?.configure(model: model) { [weak self] in
                self?.presenter.payInCurrency(at: indexPath)
            }
        }
        return cell
    }
}
