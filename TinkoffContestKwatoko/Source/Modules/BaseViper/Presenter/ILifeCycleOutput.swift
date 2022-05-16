//
//  ILifeCycleOutput.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

protocol ILifeCycleOutput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewDidDisappear()
}

//default implementation
extension ILifeCycleOutput {
    
    func viewDidLoad() {
        //do nothing
    }

    func viewWillAppear() {
        //do nothing
    }

    func viewDidAppear() {
        //do nothing
    }

    func viewDidDisappear() {
        //do nothing
    }
}
