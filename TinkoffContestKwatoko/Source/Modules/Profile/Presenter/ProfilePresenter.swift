//
//  ProfilePresenter.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit
import TinkoffInvestSDK
import Combine
import CombineGRPC

final class ProfilePresenter: BasePresenter {

    enum Section {
        case tokens, exchange, sandbox, logout

        var title: String? {
            switch self {
            case .tokens, .logout: return nil
            case .exchange: return "Биржа"
            case .sandbox: return "Песочница"
            }
        }
    }

    enum Action: IRowAction {
        case login, logout, manage

        var title: String {
            switch self {
            case .login: return "Войти"
            case .logout: return "Выйти"
            case .manage: return "Управлять"
            }
        }

        var color: UIColor {
            switch self {
            case .login, .manage: return .systemBlue
            case .logout: return .systemRed
            }
        }
    }

    let interactor: IProfileInteractor
    let router: IProfileRouter
    weak var viewController: IProfileView?

    var cancellables = Set<AnyCancellable>()

    var profile: Profile?
    var exchangeAccounts = [Account]()
    var sandboxAccounts = [Account]()

    lazy var tokensModel = ProfileTokensCell.Model(token: profile?.token,
                                                   sandoxToken: profile?.sandboxToken)

    init(interactor: IProfileInteractor, router: IProfileRouter) {
        self.interactor = interactor
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension ProfilePresenter {

    func configure() {
        profile = interactor.fetchProfile()
        guard let profile = self.profile else { return }
        reloadAccounts(token: profile.token,
                       sandboxToken: profile.sandboxToken)
    }

    func reloadAccounts(token: String, sandboxToken: String, _ completion: ((Error?) -> Void)? = nil) {
        viewController?.isProcessing = true

        interactor.prepareSdk(token: token, sandboxToken: sandboxToken)

        interactor.getAccounts()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.viewController?.isProcessing = false
                    self?.viewController?.reloadData()
                    completion?(error)
                case .finished:
                    self?.reloadSandboxAccounts(token: token, sandboxToken: sandboxToken, completion: completion)
                }
            } receiveValue: { [weak self] in
                self?.exchangeAccounts = $0.accounts
            }.store(in: &cancellables)
    }

    func reloadSandboxAccounts(token: String, sandboxToken: String, completion: ((Error?) -> Void)?) {
        interactor.getSandboxAccounts()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.viewController?.isProcessing = false
                self?.viewController?.reloadData()
                switch result {
                case .failure(let error):
                    completion?(error)
                case .finished:
                    completion?(nil)
                }
            } receiveValue: { [weak self] in
                self?.sandboxAccounts = $0.accounts
                let profile = Profile(token: token,
                                      sandboxToken: sandboxToken,
                                      selectedAccountId: self?.profile?.selectedAccountId ?? self?.sandboxAccounts.first?.id)
                self?.updateProfile(profile)
            }.store(in: &cancellables)
    }

    func updateSelectedAccount(id: String) {
        guard let profile = self.profile else { return }
        let newProfile = Profile(token: profile.token,
                                 sandboxToken: profile.sandboxToken,
                                 selectedAccountId: id)
        updateProfile(newProfile)
    }

    func updateProfile(_ profile: Profile) {
        self.profile = profile
        interactor.updateProfile(token: profile.token,
                                 sandboxToken: profile.sandboxToken,
                                 accountId: profile.selectedAccountId)
    }

    func login() {
        guard let token = tokensModel.token,
              token.isEmpty == false,
              let sandboxToken = tokensModel.sandoxToken,
              sandboxToken.isEmpty == false
        else { return }

        reloadAccounts(token: token, sandboxToken: sandboxToken) { [weak self] in
            if let error = $0 {
                self?.handleError(error)
            } else {
                self?.router.login()
            }
        }
    }

    func logout() {
        let controller = UIAlertController(confirm: "Вы уверены что хотите выйти?",
                                           message: "Все данные (роботы, конфигурации, история) будут безвозвратно удалены",
                                           actionTitle: "Выйти") { [weak self] in
            self?.profile = nil
            self?.interactor.clearDatabase()
            self?.viewController?.reloadData()
            self?.router.logout()
        }
        router.present(controller, animated: true)
    }

    func manageSandbox() {

    }

    func handleError(_ error: Error) {
        let text: String
        if let rpcError = error as? RPCError,
           let message = rpcError.status.message
            ?? rpcError.trailingMetadata?.first(name: "message") {
            text = message
        } else {
            text = error.localizedDescription
        }

        router.presentAlert(title: nil,
                            message: text,
                            actions: [.init(title: "Закрыть", style: .default)])
    }
}

extension ProfilePresenter: IProfilePresenter {

    var sections: [Section] {
        return profile == nil
            ? [.tokens]
            : [.logout, .sandbox, .exchange]
    }

    func numberOfRows(inSection index: Int) -> Int {
        let section = sections[index]
        switch section {
        case .logout: return 1
        case .tokens: return 2
        case .exchange: return exchangeAccounts.count
        case .sandbox: return sandboxAccounts.count + 1
        }
    }

    func accountModel(at indexPath: IndexPath) -> ProfileAccountCell.Model? {
        let account: Account?

        let section = sections[indexPath.section]
        switch section {
        case .tokens, .logout: account = nil
        case .exchange: account = exchangeAccounts[indexPath.row]
        case .sandbox: account = sandboxAccounts[indexPath.row]
        }

        let name = account?.name.isEmpty == false ? account?.name : account?.id
        let model = ProfileAccountCell.Model(title: name,
                                             isSelected: account?.id == profile?.selectedAccountId)
        return model
    }

    func action(at indexPath: IndexPath) -> IRowAction? {
        let section = sections[indexPath.section]
        let action: Action?
        switch section {
        case .tokens: action = .login
        case .logout: action = .logout
        case .sandbox: action = .manage
        case .exchange: action = nil
        }
        return action
    }

    func didSelectRow(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .exchange:
            let account = exchangeAccounts[indexPath.row]
            updateSelectedAccount(id: account.id)
            router.presentAlert(title: "Внимание!",
                                message: "Все сделки будут совершаться на реальной бирже.\nБудьте внимательны с работой работа",
                                actions: [.init(title: "Закрыть", style: .cancel)])
        case .sandbox:
            if indexPath.row < sandboxAccounts.count {
                let account = sandboxAccounts[indexPath.row]
                updateSelectedAccount(id: account.id)
            } else if indexPath.row == numberOfRows(inSection: indexPath.section) - 1 {
                manageSandbox()
            }
        case .tokens:
            if indexPath.row == numberOfRows(inSection: indexPath.section) - 1 {
                login()
            }
        case .logout:
            logout()
        }
        viewController?.reloadData()
    }
}
