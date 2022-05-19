//
//  HistoryViewController.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class HistoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var presenter: IHistoryPresenter!

    init(presenter: IHistoryPresenter) {
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

private extension HistoryViewController {

    func configure() {

    }
}

extension HistoryViewController: IHistoryView {

    func reloadData() {
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter.sections[section]
        switch section {
        case .robots: return presenter.robotsCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .robots: return dequeueRobotCell(tableView, forRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = presenter.sections[section]
        return section.title
    }
}

extension HistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }
}

// MARK: Dequeue

private extension HistoryViewController {

    func dequeueRobotCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RobotsRobotCell.reuseIdentifier, for: indexPath)
        let model = presenter.robotModel(at: indexPath)
        (cell as? RobotsRobotCell)?.configure(model: model) { _ in }
        return cell
    }
}
