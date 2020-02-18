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
    
    func present(_ destination: Destination, with presentationStyle: UIModalPresentationStyle = .fullScreen) {
        if let rootController = dependencyContainer.navigationController.viewControllers.first {
            let viewController = makeViewController(for: destination)
            viewController.modalPresentationStyle = presentationStyle
            rootController.present(viewController, animated: true, completion: nil)
        }
    }
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        // TODO: Create profile view controller
        
        switch destination {
        case .profile:
            break
        case .sighting:
            return dependencyContainer.makeSightingViewController()
        }
        
        return UIViewController()
    }
}
