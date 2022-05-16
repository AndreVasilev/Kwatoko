//
//  RootViewController.swift
//
//  Created by Andrey Vasilev on 07/12/2020.
//  Copyright © 2020 Andrey Vasilev. All rights reserved.
//

import UIKit

final class RootViewController: BaseViewController {

    var presenter: IRootPresenter!

    init(presenter: IRootPresenter) {
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

private extension RootViewController {

    func configure() {

    }
}

extension RootViewController: IRootView {

}
