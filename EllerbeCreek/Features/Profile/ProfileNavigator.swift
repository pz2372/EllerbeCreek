//
//  ProfileNavigator.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 4/7/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class ProfileNavigator: Navigator {
    enum Destination {
        case gameMap
        case sessionDetail(_ session: Session, _ delegate: UIViewControllerTransitioningDelegate)
        case settings
    }
    
    var dependencyContainer: CoreDependencyContainer & KeyValueStorable
    
    init(dependencyContainer: CoreDependencyContainer & KeyValueStorable) {
        self.dependencyContainer = dependencyContainer
    }
    
    func navigate(to destination: ProfileNavigator.Destination) {
        let viewController = makeViewController(for: destination)
        dependencyContainer.navigationController.viewControllers = [viewController]
    }
    
    func present(_ destination: Destination, with presentationStyle: UIModalPresentationStyle = .fullScreen) {
        if let rootController = dependencyContainer.profileNavigationController.viewControllers.first {
            let viewController = makeViewController(for: destination)
            viewController.modalPresentationStyle = presentationStyle
            viewController.modalPresentationCapturesStatusBarAppearance = true
            rootController.present(viewController, animated: true, completion: nil)
        }
    }
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .gameMap:
            return dependencyContainer.makeGameMapViewController()
        case .sessionDetail(let session, let delegate):
            let controller = dependencyContainer.makeSessionDetailViewController(session: session)
            controller.transitioningDelegate = delegate
            return controller
        case .settings:
            return dependencyContainer.makeSettingsViewController()
        }
    }
}


