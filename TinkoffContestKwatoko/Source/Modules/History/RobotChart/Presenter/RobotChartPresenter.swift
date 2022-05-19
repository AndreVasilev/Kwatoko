//
//  RobotChartPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class RobotChartPresenter: BasePresenter {

    let interactor: IRobotChartInteractor
    let router: IRobotChartRouter

    init(interactor: IRobotChartInteractor, router: IRobotChartRouter) {
        self.interactor = interactor
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension RobotChartPresenter: IRobotChartPresenter {

}
