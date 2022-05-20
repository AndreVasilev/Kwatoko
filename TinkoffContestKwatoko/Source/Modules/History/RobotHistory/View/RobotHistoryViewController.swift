//
//  RobotHistoryViewController.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class RobotHistoryViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    var presenter: IRobotHistoryPresenter!
    var chartCellAssembly: IRobotChartCellAssembly!

    init(presenter: IRobotHistoryPresenter) {
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

private extension RobotHistoryViewController {

    func configure() {

    }
}

extension RobotHistoryViewController: IRobotHistoryView {

    func reloadData() {
        tableView.registerNib(cellClass: RobotChartCell.self)
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension RobotHistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter.sections[section]
        switch section {
        case .info, .chart: return 1
        case .deals: return presenter.deals.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .info: return dequeueInfoCell(tableView, forRowAt: indexPath)
        case .chart: return dequeueChartCell(tableView, forRowAt: indexPath)
        case .deals: return dequeueDealCell(tableView, forRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = presenter.sections[section]
        return section.title
    }
}

// MARK: UITableViewDelegate

extension RobotHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let section = presenter.sections[indexPath.section]
        switch section {
        case .info: presenter.showRobotConfig()
        case .chart, .deals: return
        }
    }
}

// MARK: Dequeue

private extension RobotHistoryViewController {

    func dequeueInfoCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RobotHistoryInfoCell.reuseIdentifier, for: indexPath)
        (cell as? RobotHistoryInfoCell)?.configure(model: presenter.info)
        return cell
    }

    func dequeueChartCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        return chartCellAssembly.build(deals: presenter.deals, tableView: tableView, indexPath: indexPath)
    }

    func dequeueDealCell(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RobotHistoryDealCell.reuseIdentifier, for: indexPath)
        let deal = presenter.deals[indexPath.row]
        (cell as? RobotHistoryDealCell)?.configure(deal: deal)
        return cell
    }
}
