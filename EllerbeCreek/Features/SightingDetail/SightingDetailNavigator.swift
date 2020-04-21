//
//  SightingDetailNavigator.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/24/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class SightingDetailNavigator: Navigator {
    enum Destination {
        case gameMap
    }
    
    var dependencyContainer: CoreDependencyContainer & KeyValueStorable
    
    init(dependencyContainer: CoreDependencyContainer & KeyValueStorable) {
        self.dependencyContainer = dependencyContainer
    }
    
    func navigate(to destination: SightingDetailNavigator.Destination) {
        let viewController = makeViewController(for: destination)
        dependencyContainer.navigationController.viewControllers = [viewController]
    }
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .gameMap:
            return dependencyContainer.makeGameMapViewController()
        }
    }
}
