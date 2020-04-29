//
//  SettingsNavigator.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/27/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class SettingsNavigator: Navigator {
    
    enum Destination {
        case profile
    }

    var dependencyContainer: CoreDependencyContainer & KeyValueStorable

    init(dependencyContainer: CoreDependencyContainer & KeyValueStorable) {
        self.dependencyContainer = dependencyContainer
    }

    func navigate(to destination: SettingsNavigator.Destination) {
        let viewController = makeViewController(for: destination)
        dependencyContainer.navigationController.viewControllers = [viewController]
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        window.rootViewController = dependencyContainer.navigationController
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
    }

    func present(_ destination: Destination, with presentationStyle: UIModalPresentationStyle = .fullScreen) {
        if let rootController = dependencyContainer.profileNavigationController.viewControllers.first {
            let viewController = makeViewController(for: destination)
            viewController.modalPresentationStyle = presentationStyle
            rootController.present(viewController, animated: true, completion: nil)
        }
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .profile:
            return dependencyContainer.makeProfileViewController()
        }
    }

    
}
