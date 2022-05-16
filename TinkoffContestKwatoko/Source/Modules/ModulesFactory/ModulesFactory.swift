//
//  ModulesFactory.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

protocol IModulesFactory {

    var core: ICore { get }

    var rootAssembly: RootAssembly { get }
}

final class ModulesFactory {

    let core: ICore

    init(core: ICore) {
        self.core = core
    }
}

extension ModulesFactory: IModulesFactory {

    var rootAssembly: RootAssembly {
        return RootAssembly(modulesFactory: self)
    }
}
