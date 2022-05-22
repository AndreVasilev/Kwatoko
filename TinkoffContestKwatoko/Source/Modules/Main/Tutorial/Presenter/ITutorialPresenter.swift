//
//  ITutorialPresenter.swift
//
//  Created by Andrey Vasilev on 22/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol ITutorialPresenter: ILifeCycleOutput {

    var pages: [TutorialPage] { get }
}
