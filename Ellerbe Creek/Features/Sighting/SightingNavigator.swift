//
//  SightingNavigator.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/14/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class SightingNavigator: Navigator {
    enum Destination {
        case gameMap
        case sightingDetail
    }
    
    var dependencyContainer: CoreDependencyContainer & KeyValueStorable
    
    init(dependencyContainer: CoreDependencyContainer & KeyValueStorable) {
        self.dependencyContainer = dependencyContainer
    }
    
    func navigate(to destination: SightingNavigator.Destination) {
        let viewController = makeViewController(for: destination)
        dependencyContainer.navigationController.viewControllers = [viewController]
    }
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        // TODO: Create sightingDetail view controller
        
        switch destination {
        case .gameMap:
            return dependencyContainer.makeGameMapViewController()
        case .sightingDetail:
            break
        }
        
        return UIViewController()
    }
}

