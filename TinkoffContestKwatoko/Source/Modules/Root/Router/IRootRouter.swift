//
//  IRootRouter.swift
//
//  Created by Andrey Vasilev on 07/12/2020.
//  Copyright © 2020 Andrey Vasilev. All rights reserved.
//

import UIKit

protocol IRootRouter: IBaseRouter {

    func presentMain(delegate: UITabBarControllerDelegate?)
}
