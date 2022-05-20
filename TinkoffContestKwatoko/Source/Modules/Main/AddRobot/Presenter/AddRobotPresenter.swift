//
//  AddRobotPresenter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import UIKit

final class AddRobotPresenter: BasePresenter {

    enum Section {
        case strategy, instrument, config, actions

        var title: String? {
            switch self {
            case .strategy: return "Стратегия"
            case .instrument: return "Инструмент"
            case .config: return "Конфигурация"
            case .actions: return nil
            }
        }

        var description: String? {
            switch self {
            case .strategy: return "Выберите стратегию"
            case .instrument: return "Выберите инструмент"
            case .config, .actions: return nil
            }
        }
    }

    enum Action: IRowAction {
        case save

        var title: String {
            switch self {
            case .save: return "Сохранить"
            }
        }

        var color: UIColor {
            switch self {
            case .save: return .systemBlue
            }
        }
    }

    let interactor: IAddRobotInteractor
    let router: IAddRobotRouter
    weak var viewController: IAddRobotView?
    
    var strategy: Strategy?
    var instrument: IInstrument?
    var config: IStrategyConfig?
    var robotName: String? = "Робот \(Date())"

    let isEditable = true

    init(interactor: IAddRobotInteractor, router: IAddRobotRouter) {
        self.interactor = interactor
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fastSelectStrategy()
    }
}

private extension AddRobotPresenter {

    func fastSelectStrategy() {
        guard Strategy.allCases.count == 1,
              let strategy = Strategy.allCases.first,
              interactor.didOpenInfo(strategy: strategy)
        else { return }
        self.strategy = strategy
    }

    func selectStrategy() {
        router.showStrategies { [weak self] in
            guard self?.strategy != $0 else { return }
            self?.strategy = $0
            self?.instrument = nil
            self?.config = nil
            self?.viewController?.reloadData()
        }
    }

    func selectInstrument() {
        router.showInstruments { [weak self] in
            self?.instrument = $0
            if let strategy = self?.strategy,
               let accountId = self?.interactor.accountId {
                switch strategy {
                case .contest:
                    self?.config = ContestStrategy.Config(id: UUID().uuidString,
                                                          accountID: accountId,
                                                          instrument: $0)
                }
            } else {
                self?.config = nil
            }
            self?.viewController?.reloadData()
        }
    }

    func saveRobot() {
        guard let name = robotName,
              let strategy = self.strategy,
              let config = self.config,
              let robot = interactor.addRobot(name: name, strategy: strategy, config: config)
        else { return }
        router.showRobot(robot)
    }
}

extension AddRobotPresenter: IAddRobotPresenter {

    var sections: [Section] {
        return strategy == nil
        ? [.strategy, .actions]
        : instrument == nil
            ? [.strategy, .instrument, .actions]
            : [.strategy, .instrument, .config, .actions]
    }

    var actions: [Action] {
        return config == nil ? [] : [.save]
    }

    var configCellModel: ContestStrategyConfigCell.Model? {
        return .init(name: robotName,
                     config: config)
    }

    func didSelectRow(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .strategy: selectStrategy()
        case .instrument: selectInstrument()
        case .actions:
            let action = actions[indexPath.row]
            switch action {
            case .save: saveRobot()
            }
        case .config: break
        }
    }

    func didEditConfig(_ model: ContestStrategyConfigCell.Model?) {
        self.config = model?.config
        robotName = model?.name
    }
}
