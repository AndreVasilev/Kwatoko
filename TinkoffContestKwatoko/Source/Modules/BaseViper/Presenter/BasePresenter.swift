//
//  BasePresenter.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import UIKit
import CombineGRPC

class BasePresenter: ILifeCycleOutput {
    
    private let router: IBaseRouter
    
    init(router: IBaseRouter) {
        self.router = router
    }
    
    enum ErrorAlertStyle {
        case none, alert, banner
    }
    
    func viewDidLoad() {
        //do nothing
    }

    func viewWillAppear() {
        //do nothing
    }

    func viewDidDisappear() {
        //do nothing
    }

    func viewDidAppear() {
        //do nothing
    }
    
    // MARK: Handling errors
    
    func handleError(_ error: Error) {
        handleError(error, style: .banner)
    }
    
    func handleError(_ error: Error, style: ErrorAlertStyle) {
        switch style {
        case .none: return
        case .alert: presentErrorAlert(message: error.alertMessage)
        case .banner: presentBanner(error: error)
        }
    }
    
    func presentBanner(error: Error) {
        NotificationBanner.present(error)
    }
    
    func presentErrorAlert(title: String? = nil, message: String?) {
        router.presentAlert(title: title,
                            message: message,
                            actions: [.init(title: "Закрыть", style: .default)])
    }
}
