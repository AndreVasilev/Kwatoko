//
//  RobotHistoryPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class RobotHistoryPresenter: BasePresenter {

    enum Section {
        case info, deals

        var title: String? {
            switch self {
            case .info: return nil
            case .deals: return "Сделки"
            }
        }
    }

    let interactor: IRobotHistoryInteractor
    let router: IRobotHistoryRouter
    weak var viewController: IRobotHistoryView?
    let robot: Robot

    let sections: [Section] = [.info, .deals]
    var deals = [Deal]()

    init(interactor: IRobotHistoryInteractor, router: IRobotHistoryRouter, robot: Robot) {
        self.interactor = interactor
        self.router = router
        self.robot = robot
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear() {
        super.viewWillAppear()
        reloadDelas()
    }
}

private extension RobotHistoryPresenter {

    func reloadDelas() {
        deals = interactor.fetchDeals(robotId: robot.id)
        viewController?.reloadData()
    }
}

extension RobotHistoryPresenter: IRobotHistoryPresenter {

    var info: RobotHistoryInfoCell.Model { .init(title: robot.name,
                                                 description: robot.description,
                                                 total: deals.count) }

    func didSelectRow(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .info: break
        case .deals:
            let deal = deals[indexPath.row]
            router.showDealDetails(deal: deal)
        }
    }
}
