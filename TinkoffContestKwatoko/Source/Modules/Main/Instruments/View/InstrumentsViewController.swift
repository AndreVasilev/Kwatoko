//
//  InstrumentsViewController.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class InstrumentsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var serchBar: UISearchBar!

    var presenter: IInstrumentsPresenter!

    init(presenter: IInstrumentsPresenter) {
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

private extension InstrumentsViewController {

    func configure() {
        title = L10n.Localization.instruments

        tableView.keyboardDismissMode = .onDrag
        #if targetEnvironment(macCatalyst)
        tableView.sectionHeaderHeight = 40
        #endif
        
        serchBar.delegate = self
    }
}

extension InstrumentsViewController: IInstrumentsView {

    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension InstrumentsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.instrumentsCount(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InstrumentListCell.reuseIdentifier, for: indexPath)
        if let model = presenter.instrument(at: indexPath) {
            (cell as? InstrumentListCell)?.configure(model: model)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = presenter.sections[section]
        return section.title
    }
}

// MARK: UITableViewDelegate

extension InstrumentsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        presenter.presentInfo(at: indexPath)
    }
}

// MARK: UISearchBarDelegate

extension InstrumentsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterInstruments(query: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
