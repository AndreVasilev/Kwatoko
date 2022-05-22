//
//  TutorialPresenter.swift
//
//  Created by Andrey Vasilev on 22/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class TutorialPresenter: BasePresenter {
    
    let interactor: ITutorialInteractor
    let router: ITutorialRouter
    
    let tutorial: Tutorial
    
    init(interactor: ITutorialInteractor, router: ITutorialRouter, tutorial: Tutorial) {
        self.interactor = interactor
        self.router = router
        self.tutorial = tutorial
        super.init(router: router)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension TutorialPresenter: ITutorialPresenter {

    var pages: [TutorialPage] { tutorial }
}
