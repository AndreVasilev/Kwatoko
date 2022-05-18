//
//  AddRobotViewController.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit
import TinkoffInvestSDK

final class AddRobotViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var presenter: IAddRobotPresenter!

    init(presenter: IAddRobotPresenter) {
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

private extension AddRobotViewController {

    func configure() {
        tableView.keyboardDismissMode = .onDrag
    }
}

extension AddRobotViewController: IAddRobotView {

    func reloadData() {
        tableView.reloadData()
    }
}

extension AddRobotViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter.sections[section]
        switch section {
        case .strategy, .instrument, .config: return 1
        case .actions: return presenter.actions.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .strategy, .instrument: return dequeueListCell(tableView, forRowAt: indexPath)
        case .config:
            guard let strategy = presenter.strategy else { fatalError("Unsupported state") }
            switch strategy {
            case .contest:
                return dequeueContestStrategyCell(tableView, forRowAt: indexPath)
            }
        case .actions:
            return dequeueActionCell(tableView, forRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = presenter.sections[section]
        return section.title
    }
}

extension AddRobotViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .strategy, .instrument, .actions: return indexPath
        case .config: return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }
}

// MARK: Dequeue

private extension AddRobotViewController {

    func dequeueListCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddRobotListCell.reuseIdentifier, for: indexPath)
        let section = presenter.sections[indexPath.section]
        let value: String?
        switch section {
        case .strategy: value = presenter.strategy?.name
        case .instrument: value = presenter.instrument?.name
        case .config, .actions: value = nil
        }
        let title = value == nil ? section.description : nil
        (cell as? AddRobotListCell)?.configure(title: title, value: value)
        return cell
    }

    func dequeueContestStrategyCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContestStrategyConfigCell.reuseIdentifier, for: indexPath)
        (cell as? ContestStrategyConfigCell)?.configure(model: presenter.configCellModel) { [weak self] in
            self?.presenter.didEditConfig($0)
        }
        return cell
    }

    func dequeueActionCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RobotsActionCell.reuseIdentifier, for: indexPath)
        let action = presenter.actions[indexPath.row]
        (cell as? RobotsActionCell)?.configure(action: action)
        return cell
    }
}
