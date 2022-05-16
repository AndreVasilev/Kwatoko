//
//  ModulesFactory.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

protocol IModulesFactory {

    var core: ICore { get }
    var rootDelegate: IRootPresenterDelegate? { get }

    func buildAssembly<T: IAssembly>() -> T
}

final class ModulesFactory {

    let core: ICore

    weak var rootDelegate: IRootPresenterDelegate?

    init(core: ICore) {
        self.core = core
    }
}

extension ModulesFactory: IModulesFactory {

    func buildAssembly<T: IAssembly>() -> T {
        return T.init(modulesFactory: self)
    }
}
