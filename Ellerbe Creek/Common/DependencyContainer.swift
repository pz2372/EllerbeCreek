//
//  DependencyContainer.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/4/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

// Defines the core state/behavior of the dependency container that every Navigator will need access to
typealias CoreDependencyContainer = SystemNavigatable & ViewControllerFactory


class DependencyContainer: CoreDependencyContainer, KeyValueStorable {
    // When possible, make all properties lazy to avoid circular dependencies and allow to be created in any order
    
    // MARK: - SystemNavigatable
    let navigationController = UINavigationController()
    
    // MARK: - KeyValueStorable
    lazy var storage = Storage()
    
    // MARK: - ViewControllerFactory
    func makeGameMapViewController() -> GameMapViewController {
        return GameMapViewController(navigator: GameMapNavigator(dependencyContainer: self))
    }
    
}
