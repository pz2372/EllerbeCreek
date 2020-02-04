//
//  GameMapNavigator.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class GameMapNavigator: Navigator {
    enum Destination {
        case profile
        case sighting
    }
    
    var dependencyContainer: CoreDependencyContainer & KeyValueStorable
    
    init(dependencyContainer: CoreDependencyContainer & KeyValueStorable) {
        self.dependencyContainer = dependencyContainer
    }
    
    func navigate(to destination: GameMapNavigator.Destination) {
        let viewController = makeViewController(for: destination)
        dependencyContainer.navigationController.viewControllers = [viewController]
    }
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        // TODO: Create profile and sighting view controllers
        
//        switch destination {
//        case .profile:
//            return dependencyContainer.makeProfileViewController()
//        case .sighting:
//            return dependencyContainer.makeSightingViewController()
//        }
        
        return UIViewController()
    }
}
