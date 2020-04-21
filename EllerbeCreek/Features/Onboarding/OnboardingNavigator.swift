//
//  OnboardingNavigator.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 3/22/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class OnboardingNavigator: Navigator {

    enum Destination {
        case gameMap
    }

    var dependencyContainer: CoreDependencyContainer & KeyValueStorable

    init(dependencyContainer: CoreDependencyContainer & KeyValueStorable) {
        self.dependencyContainer = dependencyContainer
    }

    func navigate(to destination: OnboardingNavigator.Destination) {
        let viewController = makeViewController(for: destination)
        dependencyContainer.navigationController.viewControllers = [viewController]
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        window.rootViewController = dependencyContainer.navigationController
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
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
        }
    }

}
