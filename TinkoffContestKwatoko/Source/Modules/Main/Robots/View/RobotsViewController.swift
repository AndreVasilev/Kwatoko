//
//  RobotsViewController.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class RobotsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var presenter: IRobotsPresenter!

    init(presenter: IRobotsPresenter) {
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

private extension RobotsViewController {

    func configure() {

    }
}

extension RobotsViewController: IRobotsView {

    func reloadData() {
        tableView.reloadData()
    }
}

extension RobotsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter.sections[section]
        switch section {
        case .info: return 1
        case .actions: return presenter.actions.count
        case .robots: return presenter.robotsCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .info: return dequeueInfoCell(tableView, forRowAt: indexPath)
        case .actions: return dequeueActionCell(tableView, forRowAt: indexPath)
        case .robots: return dequeueRobotCell(tableView, forRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = presenter.sections[section]
        return section.title
    }
}

extension RobotsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .info: return nil
        case .actions, .robots: return indexPath
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .info, .actions: return false
        case .robots: return true
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            presenter.deleteRobot(at: indexPath.row)
        default: return
        }
    }
}

// MARK: Dequeue

private extension RobotsViewController {

    func dequeueInfoCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RobotsInfoCell.reuseIdentifier, for: indexPath)
        (cell as? RobotsInfoCell)?.configure(info: presenter.info)
        return cell
    }

    func dequeueActionCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RobotsActionCell.reuseIdentifier, for: indexPath)
        let action = presenter.actions[indexPath.row]
        (cell as? RobotsActionCell)?.configure(action: action)
        return cell
    }

    func dequeueRobotCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RobotsRobotCell.reuseIdentifier, for: indexPath)
        let model = presenter.robotModel(at: indexPath)
        (cell as? RobotsRobotCell)?.configure(model: model) { [weak self] in
            self?.presenter.setRobotState(running: $0, at: indexPath)
        }
        return cell
    }
}
