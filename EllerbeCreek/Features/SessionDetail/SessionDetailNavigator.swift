//
//  SessionDetailNavigator.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/19/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation
import UIKit

class SessionDetailNavigator: Navigator {
    
    enum Destination {
        case profile
        case sightingDetail(_ sighting: Sighting)
    }
    
    var dependencyContainer: CoreDependencyContainer & KeyValueStorable
    
    init(dependencyContainer: CoreDependencyContainer & KeyValueStorable) {
        self.dependencyContainer = dependencyContainer
    }
    
    func navigate(to destination: SessionDetailNavigator.Destination) {
        let viewController = makeViewController(for: destination)
        dependencyContainer.navigationController.viewControllers = [viewController]
    }
    
    func present(_ destination: Destination, with presentationStyle: UIModalPresentationStyle = .fullScreen) {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController, let topController = rootController.top {
            let viewController = makeViewController(for: destination)
            viewController.modalPresentationStyle = presentationStyle
            viewController.modalPresentationCapturesStatusBarAppearance = true
            topController.present(viewController, animated: true, completion: nil)
        }
    }
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .profile:
            return dependencyContainer.makeProfileViewController()
        case .sightingDetail(let sighting):
            return dependencyContainer.makeSightingDetailViewController(sighting: sighting)
        }
    }
    
}

extension UIViewController {
    var top: UIViewController? {
        if let controller = self as? UINavigationController {
            return controller.topViewController?.top
        }
        if let controller = self as? UISplitViewController {
            return controller.viewControllers.last?.top
        }
        if let controller = self as? UITabBarController {
            return controller.selectedViewController?.top
        }
        if let controller = presentedViewController {
            return controller.top
        }
        return self
    }
}
