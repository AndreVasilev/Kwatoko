//
//  ProfileViewController.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class ProfileViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    var presenter: IProfilePresenter!

    var isProcessing: Bool = false {
        didSet {
            isProcessing ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

    init(presenter: IProfilePresenter) {
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

private extension ProfileViewController {

    func configure() {
        activityIndicator.hidesWhenStopped = true
        let item = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = item
    }
}

extension ProfileViewController: IProfileView {

    func reloadData() {
        tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .tokens:
            switch indexPath.row {
            case presenter.numberOfRows(inSection: indexPath.section) - 1:
                return dequeueActionCell(tableView, forRowAt: indexPath)
            default:
                return dequeueTokensCell(tableView, forRowAt: indexPath)
            }
        case .sandbox:
            switch indexPath.row {
            case presenter.numberOfRows(inSection: indexPath.section) - 1:
                return dequeueActionCell(tableView, forRowAt: indexPath)
            default:
                return dequeueAccountCell(tableView, forRowAt: indexPath)
            }
        case .exchange:
            return dequeueAccountCell(tableView, forRowAt: indexPath)
        case .logout:
            return dequeueActionCell(tableView, forRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = presenter.sections[section]
        return section.title
    }
}

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        presenter.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        presenter.showAccount(at: indexPath)
    }
}

// MARK: Dequeue

private extension ProfileViewController {

    func dequeueTokensCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTokensCell.reuseIdentifier, for: indexPath)
        (cell as? ProfileTokensCell)?.configure(model: presenter.tokensModel)
        (cell as? ProfileTokensCell)?.onEditingDidEnd = { [weak self] in self?.presenter.tokensModel = $0 }
        (cell as? ProfileTokensCell)?.onInfoButtonPressed = { [weak self] in self?.presenter.presentTokensInfo() }
        return cell
    }

    func dequeueAccountCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileAccountCell.reuseIdentifier, for: indexPath)
        if let model = presenter.accountModel(at: indexPath) {
            (cell as? ProfileAccountCell)?.configure(model: model)
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
}
