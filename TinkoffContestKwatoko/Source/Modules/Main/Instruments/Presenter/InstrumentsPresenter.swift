//
//  InstrumentsPresenter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import Combine
import CombineGRPC

final class InstrumentsPresenter: BasePresenter {

    typealias Callback = (IInstrument) -> Void

    enum Section {
        case share

        var title: String {
            switch self {
            case .share: return "Акции"
            }
        }
    }

    let interactor: IInstrumentsInteractor
    let router: IInstrumentsRouter
    weak var viewController: IInstrumentsView?
    
    var callback: Callback?

    let sections: [Section] = [.share]
    var rawInstruments = [Section: [IInstrument]]()
    var filteredInstruments: [Section: [IInstrument]]?

    var cancellables = Set<AnyCancellable>()
    var searchQuery: String?

    init(interactor: IInstrumentsInteractor, router: IInstrumentsRouter, callback: InstrumentsPresenter.Callback?) {
        self.interactor = interactor
        self.router = router
        self.callback = callback
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadInstruments()
    }
}

private extension InstrumentsPresenter {

    var instruments: [Section: [IInstrument]] {
        if searchQuery?.isEmpty == false,
           let instruments = filteredInstruments {
            return instruments
        } else {
            return rawInstruments
        }
    }

    func reloadInstruments() {
        sections.forEach { section in
            switch section {
            case .share:
                interactor.getShares()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] result in
                      switch result {
                      case .failure(let error):
                          print(error)
                      case .finished:
                          print("did finish loading \(section)")
                          self?.viewController?.reloadData()
                      }
                    } receiveValue: { [weak self] in
                        self?.rawInstruments[section] = $0.instruments.sorted(by: { $0.name < $1.name })
                    }.store(in: &cancellables)
            }
        }
    }

    func instrument(atIndexPath indexPath: IndexPath) -> IInstrument? {
        let section = sections[indexPath.section]
        return instruments[section]?[indexPath.row]
    }
}

extension InstrumentsPresenter: IInstrumentsPresenter {

    func instrumentsCount(in section: Int) -> Int {
        let section = sections[section]
        return instruments[section]?.count ?? 0
    }

    func instrument(at indexPath: IndexPath) -> InstrumentListCell.Model? {
        guard let instrument = instrument(atIndexPath: indexPath) else { return nil }
        return .init(name: instrument.name,
                     description: instrument.ticker)
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard let instrument = instrument(atIndexPath: indexPath) else { return }
        callback?(instrument)
        router.pop()
    }

    func presentInfo(at indexPath: IndexPath) {

    }

    func filterInstruments(query: String?) {
        guard let searchText = query?.lowercased() else {
            searchQuery = nil
            filteredInstruments = nil
            viewController?.reloadData()
            return
        }
        searchQuery = searchText

        let queue = DispatchQueue(label: "searchFilter")
        let instruments = self.rawInstruments
        queue.async { [weak self] in
            var result = [Section: [IInstrument]]()
            instruments.forEach {
                result[$0.key] = $0.value.filter {
                    return [$0.name, $0.ticker]
                        .first(where: { $0.lowercased().contains(searchText) }) != nil
                }
            }

            if self?.searchQuery == searchText {
                DispatchQueue.main.async {
                    self?.filteredInstruments = result
                    self?.viewController?.reloadData()
                }
            }
        }
    }
}
