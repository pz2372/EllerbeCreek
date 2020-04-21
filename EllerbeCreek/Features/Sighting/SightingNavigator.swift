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
        case sightingDetail(_ sighting: Sighting)
    }
    
    var dependencyContainer: CoreDependencyContainer & KeyValueStorable
    
    init(dependencyContainer: CoreDependencyContainer & KeyValueStorable) {
        self.dependencyContainer = dependencyContainer
    }
    
    func navigate(to destination: SightingNavigator.Destination) {
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
        switch destination {
        case .gameMap:
            return dependencyContainer.makeGameMapViewController()
        case .sightingDetail(let sighting):
            return dependencyContainer.makeSightingDetailViewController(sighting: sighting)
        }
    }
}

