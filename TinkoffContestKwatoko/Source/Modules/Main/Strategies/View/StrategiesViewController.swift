//
//  StrategiesViewController.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class StrategiesViewController: BaseViewController {

    var presenter: IStrategiesPresenter!

    init(presenter: IStrategiesPresenter) {
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

private extension StrategiesViewController {

    func configure() {
        title = L10n.Localization.strategies
    }
}

extension StrategiesViewController: IStrategiesView {

}

extension StrategiesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.strategies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StrategyListCell.reuseIdentifier, for: indexPath)
        let strategy = presenter.strategies[indexPath.row]
        (cell as? StrategyListCell)?.configure(strategy: strategy)
        return cell
    }
}

extension StrategiesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        presenter.presentStrategyInfo(at: indexPath)
    }
}
